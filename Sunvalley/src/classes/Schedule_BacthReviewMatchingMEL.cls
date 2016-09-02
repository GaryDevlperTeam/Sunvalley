/**
*Des:Des:Review/MEL关联 引导类
*Author:Gary Hu
*Time:2015年10月10日15:50:17
**/
global class  Schedule_BacthReviewMatchingMEL implements Schedulable{
	global void execute(SchedulableContext SC) {
    ID batchprocessid = Database.executeBatch(new Bacth_Review_Matching_MEL(),1000);
  }
}