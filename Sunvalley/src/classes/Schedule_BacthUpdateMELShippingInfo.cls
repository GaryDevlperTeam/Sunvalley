/**
*Des:批量更新MEL上的 shipping 信息 引导类
*Author:Gary Hu
*Time:2015年10月11日17:45:05
**/
global class Schedule_BacthUpdateMELShippingInfo implements Schedulable{ 
	
  global void execute(SchedulableContext SC) {
    
    ID batchprocessid = Database.executeBatch(new Bacth_Update_MEL_ShippingInfo(),1000);
    
  }
}