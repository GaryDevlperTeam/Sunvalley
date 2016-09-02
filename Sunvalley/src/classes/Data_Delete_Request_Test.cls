/**

 */
@isTest
private class Data_Delete_Request_Test {

    static testMethod void myUnitTest() {
        Data_Delete_Request__c d = new Data_Delete_Request__c();
        insert d;
        d.Delete_Request__c = true;
        update d;
        Order_sku__c o = new Order_sku__c();
        o.Name = 'xxx';
        insert o;
    }
}