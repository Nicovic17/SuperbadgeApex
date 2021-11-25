trigger MaintenanceRequest on Case (after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    
    
    Map<Id, Case> mantReq  = new Map<Id, Case>();
    
    if(Trigger.isUpdate && Trigger.isAfter){
        for(Case c : Trigger.New ){
            if(c.type.equals('Repair') || c.type.equals('Routine Maintenance')){
                if(c.isClosed){
                    mantReq.put(c.id, c);
                }
            }
        }
        //Commento
        if(mantReq.size()>0){
            MaintenanceRequestHelper.updateWorkOrders(mantReq);
        }
    }
}