public with sharing class MaintenanceRequestHelper {
    
    
    public static void updateWorkOrders(Map<Id, Case> mantReqCasesRecived) {
        // TODO: Complete the method to update workorders

      //Create a new map of products id and the maintenance cycle numbers of days
        
        Map<Id, Integer> productMapCycle = new Map<Id, Integer>(); 
        
        Map<Id,Case> closedCasesM = new Map<Id,Case>(
                     [SELECT Id, Vehicle__c, Equipment__c, Equipment__r.Maintenance_Cycle__c,
                        (
                         SELECT Id,Equipment__c,Quantity__c 
                         FROM Equipment_Maintenance_Items__r
                       ) 
                      FROM Case 
                      WHERE Id IN :mantReqCasesRecived.keySet()]);
        
         //Create a empty list of cases (Mant. Req.) that will be scheduled
        List<Case> newListOfCases = new List<Case>();
        
          
        //Create a list of the Product2 (Equipments) that bring the Id and the MR Cycle of each one
        List<Product2> equipmentList = [select Id, Maintenance_Cycle__c from Product2];  
        
        //For each of those products                                
        for (Product2 oneEquipment : equipmentList) {

            //If the product is not null and if the Main. Cycle is not null
            if ((oneEquipment != null) && (oneEquipment.Maintenance_Cycle__c != null)) {
                //Then save de equipment ID and the Main. Cycle in to the map that create in te beagginig
                productMapCycle.put(oneEquipment.Id, Integer.valueOf(oneEquipment.Maintenance_Cycle__c));               
            }
        }
        
        Integer minimunCycleDays = productMapCycle.values()[0];
        for(Integer oneCycle: productMapCycle.values()){
            //System.debug('The value inside oneCycle: ' + oneCycle);
            if(oneCycle < minimunCycleDays){
                minimunCycleDays = oneCycle;
            }
        }
        
         //For each MR that we recived
        for(Case oneCaseInRecivedMR: mantReqCasesRecived.values()){
            
            
            //Create a new one
            Case newMantReq = new Case();
            
               //Link the linked vehicle to the new one
            newMantReq.Vehicle__c = oneCaseInRecivedMR.Vehicle__c;

            
            //The equipment too
            //newMantReq.ProductId = oneCaseInRecivedMR.ProductId;
            newMantReq.SLAViolation__c = oneCaseInRecivedMR.SLAViolation__c;
              newMantReq.PotentialLiability__c = oneCaseInRecivedMR.PotentialLiability__c;
            newMantReq.PotentialLiability__c = oneCaseInRecivedMR.PotentialLiability__c;

            //Asign MR as Type
            newMantReq.Type = 'Routine Maintenance';
            
            //If the subjet is null, we fill it
            newMantReq.Subject = String.isBlank(oneCaseInRecivedMR.Subject) ? 'Routine Maintenance Request' : oneCaseInRecivedMR.Subject;

              //Asign the date that is created
            newMantReq.Date_Reported__c = Date.today();
            
              //The status
            newMantReq.Status = 'New';

            
            //The product
            newMantReq.Product__c = oneCaseInRecivedMR.Product__c;

            
            //The origin
            newMantReq.Origin = oneCaseInRecivedMR.Origin;
            
            newMantReq.AccountId = oneCaseInRecivedMR.AccountId;
            newMantReq.ContactId = oneCaseInRecivedMR.ContactId;
            newMantReq.AssetId = oneCaseInRecivedMR.AssetId;
            newMAntReq.OwnerId = oneCaseInRecivedMR.OwnerId;
            
            newMAntReq.ParentId = oneCaseInRecivedMR.Id;

            //If in the map productMapCycle exist the Id of the oneCaseInRecivedMR, then put those quantity of days plus to the day of today. Else, put the today date
            newMantReq.Date_Due__c =  (productMapCycle.get(oneCaseInRecivedMR.Id) != null) ? (Date.today().addDays(Integer.valueOf(productMapCycle.get(oneCaseInRecivedMR.Id)))) : (Date.today().addDays(minimunCycleDays));
            
         newListOfCases.add(newMantReq); 
        }
        
        //Select all the EMI that have the field Maintenance_Request__c who 
      //match whit any Id that brings the trigger
        Map<Id, Equipment_Maintenance_Item__c> MRIdsEMIsContent = new Map<Id,Equipment_Maintenance_Item__c>([
            SELECT Id, Equipment__c, Maintenance_Request__c, Quantity__c 
            FROM Equipment_Maintenance_Item__c 
            WHERE Maintenance_Request__c IN:mantReqCasesRecived.keySet()]);
            
              //Create a empty list of EMI that we insert later
        List<Equipment_Maintenance_Item__c> theNewEMIs = new List<Equipment_Maintenance_Item__c>();
        
        
        if(newListOfCases.size() > 0){
            insert newListOfCases;
            
            List<Equipment_Maintenance_Item__c> clonedWPs = new List<Equipment_Maintenance_Item__c>();
            for (Case nc : newListOfCases){
                 
                
                for (Equipment_Maintenance_Item__c wp : closedCasesM.get(nc.ParentId).Equipment_Maintenance_Items__r){
                     Equipment_Maintenance_Item__c wpClone = wp.clone();
                        wpClone.Maintenance_Request__c = nc.Id;
                        ClonedWPs.add(wpClone);
                }

            }
            insert ClonedWPs;
            
        }
    }        

}