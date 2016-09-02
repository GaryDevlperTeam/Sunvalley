/**
*Des:Reviews CRM 汇总和客户相关的review 条数
*Author:Jmark
*Time:2015年10月21日13:37:11
**/
global class Schedule_BacthCalculateReviewsCRM  implements Schedulable{
	global void execute(SchedulableContext SC) {
    	ID batchprocessid = Database.executeBatch(new Bacth_CalculateReviewsCRM(),1000);
  	}
}