/**
*Des:计算复购率 
*Author:Jmark
*Time:2015年10月20日17:34:42
**/
global class Cls_WS_Repeat_Purchase_Time {
	//计算
	 webservice static String autoCalculate(ID cId)
    {
         if(cId != null)
         {
            list<Repeat_Purchase_Time__c>  listCamSku = [select Id,Calculate_End_Date__c,Calculate_Start_Date__c from  Repeat_Purchase_Time__c where Id =:cId ];
            Database.executeBatch(new Batch_Recent_Repeat_Purchase_Time(cId,listCamSku[0].Calculate_Start_Date__c,listCamSku[0].Calculate_End_Date__c), 1000);
            
         }
         return 'Success';
    }
}