trigger Mass_Email_Log on Mass_Email_Log__c (after insert, after update) {
	Cbl_MEL_updateCampaign cmeluc=new Cbl_MEL_updateCampaign();//新建或更新Mass_Email_Log__c，更新市场活动开始发货时间
    {
        if(trigger.isInsert)
        {
           cmeluc.insertMel(trigger.new);
        }
        if(trigger.isUpdate)
        {
           cmeluc.insertMel(trigger.new, trigger.oldMap);
        }
    }
}