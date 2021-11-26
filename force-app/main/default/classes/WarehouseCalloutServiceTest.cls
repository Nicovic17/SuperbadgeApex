@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here

    @isTest 
	static void testPostCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        WarehouseCalloutService callaout = new WarehouseCalloutService();
        Test.startTest();
        
         // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        //WarehouseCalloutService.runWarehouseEquipmentSync();
    	System.enqueueJob(callaout);
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Product2]);
        System.assert([Select count() From Product2 Where NAME='Generator di banane'] > 0);
    }
     
}