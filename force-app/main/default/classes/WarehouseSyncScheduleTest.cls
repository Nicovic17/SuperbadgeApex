@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    // 
    // 
    // 
    static testmethod void test() {
        String scheduleTime = '00 00 01 * * ?';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobID = System.schedule('Test', scheduleTime, new WarehouseSyncSchedule());
        Test.stopTest();
        
        /*
		Tracking the Progress of a Scheduled Job Using Queries
		*/
        CronTrigger a = [Select Id From CronTrigger Where id = :jobID];
        System.assertEquals(jobID, a.Id, 'Schedule');
        
    }
}