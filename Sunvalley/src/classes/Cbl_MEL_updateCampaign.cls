/**
*Create By:jmark
*TIME：2015年9月10日16:01:42
*Description:开始发货时间（需要在市场活动上新建），MEL.logistics_number__c(来自接口)，
*            IF MEL.logistics_number__c存在（MEL必须是市场活动相关）,开始发货时间=Today
 */
public class Cbl_MEL_updateCampaign {
    //新建时
    public void insertMel(list<Mass_Email_Log__c> list_mel)
    {
       set<Id> set_cid=new set<Id>();//市场活动Id
       for(Mass_Email_Log__c mel:list_mel)
       {
           if(mel.campaign_name__c != null && mel.shipping_date__c != null)
           {
           	   if(!set_cid.contains(mel.campaign_name__c))
           	   {
           	       set_cid.add(mel.campaign_name__c);
           	   }
               
           }
       }
       if(set_cid.size()>0)
       {
           list<Campaign> list_cp=[select start_send_time__c from Campaign where Id in:set_cid and start_send_time__c = null];
           if(list_cp != null && list_cp.size()>0)
           {
               for(Campaign cp:list_cp)
               {
                  cp.start_send_time__c=Date.today();
               }
               update list_cp;
           }
       }
    }
    //更新时
    public void insertMel(list<Mass_Email_Log__c> list_mel,map<Id,Mass_Email_Log__c> map_mel)
    {
    	list<Mass_Email_Log__c> list_needmel=new list<Mass_Email_Log__c>();
        for(Mass_Email_Log__c mel:list_mel)
       {
           if(mel.campaign_name__c != null && mel.shipping_date__c != null && map_mel.get(mel.Id).shipping_date__c == null)
           {
               list_needmel.add(mel);
           }
       }
       if(list_needmel.size()>0)
       {
          insertMel(list_needmel);
       }
    }
    
}