/**
*Des:ordersku与Campaign关联 引导类 
*Author:Gary Hu
*Time:2015年10月10日16:37:35
**/ 
global class Schedule_BacthOrderskuMatchingCampaign implements Schedulable{
	global void execute(SchedulableContext SC) {
    
    ID batchprocessid = Database.executeBatch(new Bacth_Ordersku_Matching_Campaign(),1000);
  }
}