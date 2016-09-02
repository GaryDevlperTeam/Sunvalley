/**
*Create By:jmark
*TIME：2015年9月10日10:56:32
*Description:review与Campaign关联：
*1.a）有memberlist(即customer)：customer.amazon_id__c=review.amazon_id__c
*                          review.sku__c包含在 Campaign.campaginsku.campaign_sku__c(数据集合)
*  b）没有memberlist：campagin .campaign_country__c=review.review_country__c
*                      review.sku__c包含在 Campaign.campaginsku.campaign_sku__c
*2.开始发货时间（需要在市场活动上新建），MEL.logistics_number__c(来自接口)，IF MEL.logistics_number__c存在（MEL必须是市场活动相关）,开始发货时间=Today
*3.在市场活动新建字段：review收集结束（天）(手填)，review.review_date__c落在{开始发货时间，开始发货时间+review收集结束（天）之内}
*匹配：review.campaign__c=campagin.id
**/  
global class Bacth_Review_MatchCampaign implements Database.Batchable<SObject>,Database.Stateful{

     global Database.queryLocator start(Database.BatchableContext ctx)
     {     datetime myDateTime = datetime.now().addHours(-24);    
           return Database.getQueryLocator([select amazon_id__c,campaign__c,sku__c,review_country__c,review_date__c from Review__c where campaign__c = null and sku__c != null  and SystemModStamp >=:myDateTime]); 
         
     }
     global void execute(Database.BatchableContext ctx, list<Review__c> list_rev)
     {
     
         set<String> set_sku=new set<String>();//sku__c集合
         for(Review__c rev:list_rev)
         {
            if(!set_sku.contains(rev.sku__c))
            {
               set_sku.add(rev.sku__c);
            }
         }
         list<Campaign_SKU__c> list_csku=new list<Campaign_SKU__c>();//Campaign_SKU__c记录
         set<Id> set_camId=new set<Id>();//campaign的Id
         if(set_sku.size()>0)
         {
            list_csku=[select campaign__c,campaign_sku__c from Campaign_SKU__c where campaign_sku__c in:set_sku and campaign__c != null];
            if(list_csku.size()>0)
            {
               for(Campaign_SKU__c csku:list_csku)
               {
               	  if(!set_camId.contains(csku.campaign__c))
               	  {
               	     set_camId.add(csku.campaign__c);
               	  }
               }
            }
         }
         list<Campaign> list_cp=new list<Campaign>();//符合review.sku__c包含在 Campaign.campaginsku.campaign_sku__c(数据集合)
         list<Campaign_SKU__c> list_allcsku=new list<Campaign_SKU__c>();
         list<CampaignMember > list_cm=new list<CampaignMember >();
         map<Id,Set<String>> map_csku=new map<Id,Set<String>>();
         map<Id,Set<String>> map_acc=new map<Id,Set<String>>();
         if(set_camId.size()>0)
         {
            list_cp=[select Id,campaign_country__c,review_collect_end_day__c,start_send_time__c from Campaign where Id in:set_camId and review_collect_end_day__c != null and start_send_time__c != null];
            list_allcsku=[select campaign__c,campaign_sku__c from Campaign_SKU__c where campaign__c in:set_camId and campaign_sku__c != null];
            list_cm=[Select Contact.Account.amazon_id__c,CampaignId From CampaignMember where CampaignId in:set_camId and Contact.Account.amazon_id__c != null]; 
            if(list_allcsku.size()>0)//按市场活动Id给Campaign_SKU__c分组
            {
                for(Campaign_SKU__c csku:list_allcsku)
                {
                    if(map_csku.containsKey(csku.campaign__c))
                    {
                        map_csku.get(csku.campaign__c).add(csku.campaign_sku__c);
                    }
                    else
                    {
                        Set<String> set_newcsku=new Set<String>();
                        set_newcsku.add(csku.campaign_sku__c);
                        map_csku.put(csku.campaign__c,set_newcsku);
                    }
                }
            }
            if(list_cm.size()>0)//按市场活动Id给市场活动成员分组
            {
                for(CampaignMember cm:list_cm)
                {
                    if(map_acc.containsKey(cm.CampaignId))
                    {
                        map_acc.get(cm.CampaignId).add(cm.Contact.Account.amazon_id__c);
                    }
                    else
                    {
                        Set<String> set_newacc=new Set<String>();
                        set_newacc.add(cm.Contact.Account.amazon_id__c);
                        map_acc.put(cm.CampaignId,set_newacc);
                    }
                }
            }
            list<Review__c> list_update=new list<Review__c>();//需要更新的Review__c
             for(Review__c rev:list_rev)//匹配赋值
             {
                for(Campaign cp:list_cp)
                {
                   if(map_acc.get(cp.Id) != null)//有memberlist(即customer)
                   {
                      if(map_acc.get(cp.Id).contains(rev.amazon_id__c))
                      {
                         if(map_csku.get(cp.Id)!= null && map_csku.get(cp.Id).contains(rev.sku__c))
                         {
                             Date startdate=cp.start_send_time__c;
                             Date enddate=startdate.addDays(Integer.valueOf(cp.review_collect_end_day__c));
                             if(rev.review_date__c >= startdate && enddate >= rev.review_date__c)
                             {
                                 rev.campaign__c=cp.Id;
                                 list_update.add(rev);
                                 break;
                             }
                         }
                      }
                      
                   }
                   else//没有memberlist
                   {
                       system.debug('没有memberlist');
                       if(map_csku.get(cp.Id)!= null && map_csku.get(cp.Id).contains(rev.sku__c) && rev.review_country__c == cp.campaign_country__c && rev.review_country__c != null)
                       {
                             system.debug('匹配了');
                             Date startdate=cp.start_send_time__c;
                             Date enddate=startdate.addDays(Integer.valueOf(cp.review_collect_end_day__c));
                             if(rev.review_date__c >= startdate && enddate >= rev.review_date__c)
                             {
                                 rev.campaign__c=cp.Id;
                                 list_update.add(rev);
                                 break;
                             }
                       }
                   }
                }
             }
             if(list_update.size()>0)
             {
                update list_update;
             }
         }
        
         
     }
     global void finish(Database.BatchableContext ctx)
     {
         
     }
}