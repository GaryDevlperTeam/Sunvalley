/**
*Des:Mails click Is Click=Ture 汇总客户关联MEL
Mails Open Is Open=Ture 汇总客户关联MEL
Recent Contact Date 最近一条MEL的创建日期
Review Accept 汇总和客户相关的MEL的is apccept=1的接受数量 
Review Finish 汇总和客户相关的MEL的is reviewed=1的数量 
Review Request 汇总MEL.Campaign Type=Super User 
Reviewer Feedback Rate 接受到完成时间天数（只取最近一次）MEL.Accept Date减去MEL.Review Date
*Author:Gary Hu
*Time:2015年10月27日15:35:29
**/
global class Schedule_Bacth_Count_MEL  implements Schedulable{
	global void execute(SchedulableContext SC) {
    	ID batchprocessid = Database.executeBatch(new Bacth_Count_MEL(),1000);
  	}
}