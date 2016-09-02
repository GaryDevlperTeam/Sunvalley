/**
*Dis:“市场活动成员”对象的触发器
*Author:Gavin Li
*Time:2015年11月02日14:55:23
**/
trigger CampaignMember on CampaignMember (after insert,after delete) {
	Cbl_CampaignMember_UpdateCSL ccu = new Cbl_CampaignMember_UpdateCSL();//新建"市场活动成员"，通过“市场活动”，“联系人”字段，赋值字段Campaign Sku List
	Cbl_CampaignMember_DeleteCSL ccd = new Cbl_CampaignMember_DeleteCSL();//删除"市场活动成员"，通过“市场活动”，“联系人”字段，更新字段Campaign Sku List
 	if(trigger.isAfter)
    {
       	if(trigger.isInsert)
       {
       	ccu.updateCSL(trigger.new);//赋值字段Campaign Sku List
       }
       if(trigger.isDelete)
       {
       	ccd.deleteCS(trigger.old);//更新字段Campaign Sku List
       }
	}
}