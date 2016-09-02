/**
*Des: Campaign Times 参加活动次数 
Mails Send 参加过的Campaign的EDM Event数量
*Author:Gary Hu
*Time；2015年10月21日9:13:44
**/
global class Schedule_Bacth_Count_Campaign  implements Schedulable{
	global void execute(SchedulableContext SC) {
    	ID batchprocessid = Database.executeBatch(new Bacth_Count_Campaign(),1000);
  	}
}