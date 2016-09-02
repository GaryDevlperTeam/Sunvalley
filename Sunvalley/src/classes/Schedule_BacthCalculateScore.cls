/**
*Des:计算客户上的Score类字段
*Author:Jmark
*Time:2015年10月22日14:04:39
**/
global class Schedule_BacthCalculateScore  implements Schedulable{
	global void execute(SchedulableContext SC) {
    	ID batchprocessid = Database.executeBatch(new Bacth_CalculateScore(),1000);
  	}
}