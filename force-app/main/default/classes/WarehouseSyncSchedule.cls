global with sharing class WarehouseSyncSchedule  implements Schedulable{
    // implement scheduled code here
     global void execute(SchedulableContext ctx) {
       
        //Commento
         System.enqueueJob(new WarehouseCalloutService());
    }
}