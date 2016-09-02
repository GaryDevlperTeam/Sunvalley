/**
*Des:Mails click Is Click=Ture 汇总客户关联MEL
Mails Open Is Open=Ture 汇总客户关联MEL
Recent Contact Date 最近一条MEL的创建日期
Review Accept 汇总和客户相关的MEL的is apccept=1的接受数量 
Review Finish 汇总和客户相关的MEL的is reviewed=1的数量 
Review Request 汇总MEL.Campaign Type=Super User 
Reviewer Feedback Rate 接受到完成时间天数（只取最近一次）MEL.Accept Date减去MEL.Review Date
*Author:Gary Hu
*Time:2015年10月21日13:26:22
**/
global class Bacth_Count_MEL implements  Database.Batchable<sObject>{
	 global Database.QueryLocator start(Database.BatchableContext BC) {
	 	return Database.getQueryLocator([select Id,mails_click__c,mails_open__c,recent_contact_date__c
	 									 ,review_accept__c,review_finish__c,review_request__c,reviewer_feedback_rate__c from  Account]); 
	 }
	 global void execute(Database.BatchableContext ctx,list<Account> list_acc) {
	 	if(list_acc.size() > 0)
	 	{
	 		set<Id> setAccId = new set<Id>();
	 		for(Account a: list_acc)
	 		{
	 			setAccId.add(a.id);
	 		}
	 		if(setAccId.size() > 0)
	 		{
	 			
	 			//Mails click Is Click=Ture 汇总客户关联MEL
	 			map<Id,integer> mapIsClick = new map<Id,integer>();
	 			AggregateResult []  countMELIsClick = [select count(Id) countClick, customer__c from Mass_Email_Log__c 
	 													where customer__c in:setAccId and is_click__c = true group by customer__c];
	 			if(countMELIsClick.size() > 0)
	 			{
	 				for(AggregateResult a: countMELIsClick)
	 				{
	 					if(!mapIsClick.containsKey(String.valueOf(a.get('customer__c'))))
	 					{
	 						mapIsClick.put(String.valueOf(a.get('customer__c')),integer.valueOf(a.get('countClick')));
	 					}
	 				}
	 			}
	 			//Mails Open Is Open=Ture 汇总客户关联MEL
	 			map<Id,integer> mapIsOpen = new map<Id,integer>();
	 			AggregateResult [] countMELIsOpen = [select count(Id) countOpen, customer__c from Mass_Email_Log__c 
	 													where customer__c in:setAccId and is_open__c = true group by customer__c];
	 			if(countMELIsOpen.size() > 0)
	 			{
	 				for(AggregateResult a: countMELIsOpen)
	 				{
	 					if(!mapIsOpen.containsKey(String.valueOf(a.get('customer__c'))))
	 					{
	 						mapIsOpen.put(String.valueOf(a.get('customer__c')),integer.valueOf(a.get('countOpen')));
	 					}
	 				}
	 			}
	 			//Recent Contact Date 最近一条MEL的创建日期
	 			map<Id,Date> mapConDate = new map<Id,Date>();
	 			list<Mass_Email_Log__c> listMel = [select Id,CreatedDate,customer__c 
	 												from Mass_Email_Log__c where customer__c  != null and customer__c in:setAccId order by CreatedDate desc];
	 			if(listMel.size() > 0)
	 			{
	 				for(Mass_Email_Log__c m:listMel)
	 				{
	 					if(!mapConDate.containsKey(m.customer__c))
	 					{
	 						mapConDate.put(m.customer__c,Date.valueOf(m.CreatedDate));
	 					}
	 				}
	 			}
	 			//Review Accept 汇总和客户相关的MEL的is apccept=1的接受数量
	 			map<Id,integer> mapReviewAccept = new map<Id,integer>();
	 			AggregateResult [] countReviewAccept = [select count(Id) countRA, customer__c from Mass_Email_Log__c 
	 													where customer__c in:setAccId and is_accept__c = true group by customer__c];
	 			if(countReviewAccept.size() > 0)
	 			{
	 				for(AggregateResult a: countReviewAccept)
	 				{
	 					if(!mapReviewAccept.containsKey(String.valueOf(a.get('customer__c'))))
	 					{
	 						mapReviewAccept.put(String.valueOf(a.get('customer__c')),integer.valueOf(a.get('countRA')));
	 					}
	 				}
	 			}
	 			//Review Finish 汇总和客户相关的MEL的is reviewed=1的数量 
	 			map<Id,integer> mapReviewFinish = new map<Id,integer>();
	 			AggregateResult [] countReviewFinish = [select count(Id) countRF, customer__c from Mass_Email_Log__c 
	 													where customer__c in:setAccId and is_review__c = true group by customer__c];
	 			if(countReviewFinish.size() > 0)
	 			{
	 				for(AggregateResult a: countReviewFinish)
	 				{
	 					if(!mapReviewFinish.containsKey(String.valueOf(a.get('customer__c'))))
	 					{
	 						mapReviewFinish.put(String.valueOf(a.get('customer__c')),integer.valueOf(a.get('countRF')));
	 					}
	 				}
	 			}
	 			//Review Request 汇总MEL.Campaign Type=Super User
	 			map<Id,integer> mapReviewRequest = new map<Id,integer>();
	 			AggregateResult [] countReviewRequest = [select count(Id) countRR, customer__c from Mass_Email_Log__c 
	 													where customer__c in:setAccId and campaign_name__r.campaign_type__c = 'Superuser' group by customer__c];
	 			if(countReviewRequest.size() > 0)
	 			{
	 				for(AggregateResult a: countReviewRequest)
	 				{
	 					if(!mapReviewRequest.containsKey(String.valueOf(a.get('customer__c'))))
	 					{
	 						mapReviewRequest.put(String.valueOf(a.get('customer__c')),integer.valueOf(a.get('countRR')));
	 					}
	 				}
	 			}
	 			
	 			//Reviewer Feedback Rate 接受到完成时间天数（只取最近一次）MEL.Review Date 减去 MEL.Accept Date
	 			map<Id,integer> mapRFR = new map<Id,integer>();
	 			list<Mass_Email_Log__c> listMelRFR = [select Id,accepted_date__c,review_date__c,customer__c 
	 											  	  from Mass_Email_Log__c where accepted_date__c != null and review_date__c != null and customer__c  != null  order by CreatedDate  desc];
	 			if(listMelRFR.size() > 0)
	 			{
	 				integer day = 0;
	 				for(Mass_Email_Log__c mr: listMelRFR)
	 				{
	 					day = mr.accepted_date__c.daysBetween(mr.review_date__c);
	 					System.debug(Math.abs(day)+'-----------------------');
	 					if(!mapRFR.containsKey(mr.customer__c))
	 					{
	 						mapRFR.put(mr.customer__c,Math.abs(day));
	 					}
	 				}
	 			}
	 			for(Account acc: list_acc)
	 			{
	 				//Mails click Is Click=Ture 汇总客户关联MEL
	 				if(mapIsClick.containsKey(acc.Id))
	 				{
	 					acc.mails_click__c = mapIsClick.get(acc.Id);
	 				}
	 				//Mails Open Is Open=Ture 汇总客户关联MEL
	 				if(mapIsOpen.containsKey(acc.Id))
	 				{
	 					acc.mails_open__c = mapIsOpen.get(acc.Id);
	 				}
	 				//Recent Contact Date 最近一条MEL的创建日期
	 				if(mapConDate.containsKey(acc.Id))
	 				{
	 					acc.recent_contact_date__c = mapConDate.get(acc.Id);
	 				}
	 				//Review Accept 汇总和客户相关的MEL的is apccept=1的接受数量
	 				if(mapReviewAccept.containsKey(acc.Id))
	 				{
	 					acc.review_accept__c = mapReviewAccept.get(acc.Id);
	 				}
	 				//Review Finish 汇总和客户相关的MEL的is reviewed=1的数量 
	 				if(mapReviewFinish.containsKey(acc.Id))
	 				{
	 					acc.review_finish__c = mapReviewFinish.get(acc.Id);
	 				}
	 				//Review Request 汇总MEL.Campaign Type=Super User 
	 				if(mapReviewFinish.containsKey(acc.Id))
	 				{
	 					acc.review_finish__c = mapReviewFinish.get(acc.Id);
	 				}
	 				//Review Finish 汇总和客户相关的MEL的is reviewed=1的数量 
	 				if(mapReviewRequest.containsKey(acc.Id))
	 				{
	 					acc.review_request__c = mapReviewRequest.get(acc.Id);
	 				}
	 				//Reviewer Feedback Rate 接受到完成时间天数（只取最近一次）MEL.Review Date 减去 MEL.Accept Date
	 				if(mapRFR.containsKey(acc.Id))
	 				{
	 					acc.reviewer_feedback_rate__c = mapRFR.get(acc.Id);
	 				}
	 			}
	 			update list_acc;
	 		}
	 	}
	 }
	 global void finish(Database.BatchableContext ctx)
     {
	
     }
}