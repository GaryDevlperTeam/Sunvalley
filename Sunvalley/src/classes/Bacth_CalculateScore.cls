/**
*Des:score(Purchase Times)=[Purchase Times]/[max(Purchase Times))]              
    score(Purchase Products)=[Purchase Products)]/[max(Purchase Products)]             
	score(Purchase Total Amount)=[Purchase Total Amount]/[max(Purchase Total Amount)]           
	score(Avg Order Price)=[Avg Order Price]/[max(Avg Order Price)]              
	score(Reviews)=[Reviews]/[max(Reviews)]                
	score(Avg Review Star)=[Avg Review Star]/[max(Avg Review Star)]              
	score(Mails Open rate)=[Mails Open rate]/[max(Mails Open rate)]              
	score(Mails click rate)=[Mails click rate]/[max(Mails click rate)]             
	score(Reviewer Helpful)=[Reviewer Helpful]/[max(Reviewer Helpful)]             
	score(Reviewer Helpful Rating)=[Reviewer Helpful Rating]/[max(Reviewer Helpful Rating)]           
	score(Reviewer ranking)=[ max(Reviewer ranking) - Reviewer ranking]/[max(Reviewer ranking)] --- 0除外，即当运算结果为1时，值为0             
	score(Reviewer Avg Review Star)=[Reviewer Avg Review Star]/[max(Reviewer Avg Review Star)]          
	score(Review Accept rate)=[Review Accept rate]/[max(Review Accept rate)]            
	score(Review Finish rate)=[Review Finish rate]/[max(Review Finish rate)]            
	score(Reviewer Avg Star For Sunvalley)=[Reviewer Avg Star For Sunvalley]/[max(Reviewer Avg Star For Sunvalley)]        
	score(Reviewer Feedback Rate)=[max(Reviewer Feedback Rate) - Reviewer Feedback Rate]/max(Reviewer Feedback Rate) --- 0除外，即当运算结果为1时，值为0
*Author:Jmark
*Time:2015年10月22日13:15:38
**/ 
global class Bacth_CalculateScore implements  Database.Batchable<sObject>,Database.Stateful{
	Double  timemax=null;
	Double  promax=null;
	Double  amomax=null;
	Double  opmax=null;
	Double  rvmax=null;
	Double  starmax=null;
	Double  openmax=null;
	Double  clickmax=null;
	Double  helpmax=null;
	Double  hfratemax=null;
	Double  rankmax=null;
	Double  arsmax=null;
	Double  accmax=null;
	Double  finishmax=null;
	Double  asfsmax=null;
	Double  rfrmax=null;
    public Bacth_CalculateScore()
    {
    	/*AggregateResult[] groupedResults=[select Max(purchase_times__c) timemax,Max(purchase_products__c) promax,Max(purchase_total_amount__c) amomax,Max(avg_order_price__c) opmax,
    	                                         Max(reviews__c) rvmax,Max(avg_review_star__c) starmax,Max(mails_open_rate__c) openmax,Max(mails_click_rate__c) clickmax,
    	                                         Max(reviewer_helpful__c) helpmax,Max(reviewer_helpful_rating__c) hfratemax,Max(reviewer_ranking__c) rankmax,Max(reviewer_avg_review_star__c) arsmax,
    	                                         Max(review_accept_rate__c) accmax,Max(review_finish_rate__c) finishmax,Max(reviewer_avg_star_for_sunvalley__c) asfsmax,Max(reviewer_feedback_rate__c) rfrmax from Account];*/
    	list<Account> list_timemax=[select purchase_times__c from Account order by purchase_times__c desc nulls last limit 1];
    	list<Account> list_promax=[select purchase_products__c from Account order by purchase_products__c desc nulls last limit 1];
    	list<Account> list_amomax=[select purchase_total_amount__c from Account order by purchase_total_amount__c desc nulls last limit 1];
    	list<Account> list_opmax=[select avg_order_price__c from Account order by avg_order_price__c desc nulls last limit 1];
    	list<Account> list_rvmax=[select reviews__c from Account order by reviews__c desc nulls last limit 1];
    	list<Account> list_starmax=[select avg_review_star__c from Account order by avg_review_star__c desc nulls last limit 1];
    	list<Account> list_openmax=[select mails_open_rate__c from Account order by mails_open_rate__c desc nulls last limit 1];
    	list<Account> list_clickmax=[select mails_click_rate__c from Account order by mails_click_rate__c desc nulls last limit 1];
    	list<Account> list_helpmax=[select reviewer_helpful__c from Account order by reviewer_helpful__c desc nulls last limit 1];
    	list<Account> list_hfratemax=[select reviewer_helpful_rating__c from Account order by reviewer_helpful_rating__c desc nulls last  limit 1];
    	list<Account> list_rankmax=[select reviewer_ranking__c from Account order by reviewer_ranking__c desc nulls last limit 1];
    	list<Account> list_arsmax=[select reviewer_avg_review_star__c from Account order by reviewer_avg_review_star__c desc nulls last limit 1];
    	list<Account> list_accmax=[select review_accept_rate__c from Account order by review_accept_rate__c desc nulls last limit 1];
    	list<Account> list_finishmax=[select review_finish_rate__c from Account order by review_finish_rate__c desc nulls last limit 1];
    	list<Account> list_asfsmax=[select reviewer_avg_star_for_sunvalley__c from Account order by reviewer_avg_star_for_sunvalley__c desc nulls last limit 1];
    	list<Account> list_rfrmax=[select reviewer_feedback_rate__c from Account order by reviewer_feedback_rate__c desc nulls last limit 1];
    	if(list_timemax != null)
    	{
    	    timemax=list_timemax[0].purchase_times__c;
    	}
    	if(list_promax != null)
    	{
    	    promax=list_promax[0].purchase_products__c;
    	}
    	if(list_amomax != null)
    	{
    	    amomax=list_amomax[0].purchase_total_amount__c;
    	}
    	if(list_opmax != null)
    	{
    	    opmax=list_opmax[0].avg_order_price__c;
    	}
    	if(list_rvmax != null)
    	{
    	    rvmax=list_rvmax[0].reviews__c;
    	}
    	if(list_starmax != null)
    	{
    	    starmax=list_starmax[0].avg_review_star__c;
    	}
    	if(list_openmax != null)
    	{
    	    openmax=list_openmax[0].mails_open_rate__c;
    	}
    	if(list_clickmax != null)
    	{
    	    clickmax=list_clickmax[0].mails_click_rate__c;
    	}
    	if(list_helpmax != null)
    	{
    	    helpmax=list_helpmax[0].reviewer_helpful__c;
    	}
    	if(list_hfratemax != null)
    	{
    	    hfratemax=list_hfratemax[0].reviewer_helpful_rating__c;
    	}
    	if(list_rankmax != null)
    	{
    	    rankmax=list_rankmax[0].reviewer_ranking__c;
    	}
    	if(list_arsmax != null)
    	{
    	    arsmax=list_arsmax[0].reviewer_avg_review_star__c;
    	}
    	if(list_accmax != null)
    	{
    	    accmax=list_accmax[0].review_accept_rate__c;
    	}
    	if(list_finishmax != null)
    	{
    	    finishmax=list_finishmax[0].review_finish_rate__c;
    	}
    	if(list_asfsmax != null)
    	{
    	    asfsmax=list_asfsmax[0].reviewer_avg_star_for_sunvalley__c;
    	}
    	if(list_rfrmax != null)
    	{
    	    rfrmax=list_rfrmax[0].reviewer_feedback_rate__c;
    	}
    	
    	/*if(groupedResults.size()>0)
    	{
    	    if(groupedResults[0].get('timemax') != null)
    	    {
    	       timemax=Double.valueOf(groupedResults[0].get('timemax'));
    	    }
    	    if(groupedResults[0].get('promax') != null)
    	    {
    	       promax=Double.valueOf(groupedResults[0].get('promax'));
    	    }
    	    if(groupedResults[0].get('amomax') != null)
    	    {
    	       amomax=Double.valueOf(groupedResults[0].get('amomax'));
    	    }
    	    if(groupedResults[0].get('opmax') != null)
    	    {
    	       opmax=Double.valueOf(groupedResults[0].get('opmax'));
    	    }
    	    if(groupedResults[0].get('rvmax') != null)
    	    {
    	       rvmax=Double.valueOf(groupedResults[0].get('rvmax'));
    	    }
    	    if(groupedResults[0].get('starmax') != null)
    	    {
    	       starmax=Double.valueOf(groupedResults[0].get('starmax'));
    	    }
    	    if(groupedResults[0].get('openmax') != null)
    	    {
    	       openmax=Double.valueOf(groupedResults[0].get('openmax'));
    	    }
    	    if(groupedResults[0].get('clickmax') != null)
    	    {
    	       clickmax=Double.valueOf(groupedResults[0].get('clickmax'));
    	    }
    	    if(groupedResults[0].get('helpmax') != null)
    	    {
    	       helpmax=Double.valueOf(groupedResults[0].get('helpmax'));
    	    }
    	    if(groupedResults[0].get('hfratemax') != null)
    	    {
    	       hfratemax=Double.valueOf(groupedResults[0].get('hfratemax'));
    	    }
    	    if(groupedResults[0].get('rankmax') != null)
    	    {
    	       rankmax=Double.valueOf(groupedResults[0].get('rankmax'));
    	    }
    	    if(groupedResults[0].get('arsmax') != null)
    	    {
    	       arsmax=Double.valueOf(groupedResults[0].get('arsmax'));
    	    }
    	    if(groupedResults[0].get('accmax') != null)
    	    {
    	       accmax=Double.valueOf(groupedResults[0].get('accmax'));
    	    }
    	    if(groupedResults[0].get('finishmax') != null)
    	    {
    	       finishmax=Double.valueOf(groupedResults[0].get('finishmax'));
    	    }
    	    if(groupedResults[0].get('asfsmax') != null)
    	    {
    	       asfsmax=Double.valueOf(groupedResults[0].get('asfsmax'));
    	    }
    	    if(groupedResults[0].get('rfrmax') != null)
    	    {
    	       rfrmax=Double.valueOf(groupedResults[0].get('rfrmax'));
    	    }
    	}*/
    }
	global Database.QueryLocator start(Database.BatchableContext BC) {
	 	 return Database.getQueryLocator([SELECT Id,purchase_times__c,purchase_products__c,purchase_total_amount__c,avg_order_price__c,
	 	                                         reviews__c,avg_review_star__c,mails_open_rate__c,mails_click_rate__c,
	 	                                         reviewer_helpful__c,reviewer_helpful_rating__c,reviewer_ranking__c,reviewer_avg_review_star__c,
	 	                                         review_accept_rate__c,review_finish_rate__c,reviewer_avg_star_for_sunvalley__c,reviewer_feedback_rate__c,
	 	                                         score_avg_order_price__c,score_avg_review_star__c,score_mails_click_rate__c,score_mails_open_rate__c,
	 	                                         score_purchase_products__c,score_purchase_times__c,score_purchase_total_amount__c,score_review_accept_rate__c,
	 	                                         score_reviewer_avg_review_Star__c,score_reviewer_avg_star_for_sunvalley__c,score_reviewer_feedback_rate__c,score_reviewer_helpful__c,
	 	                                         score_reviewer_helpful_rating__c,score_reviewer_ranking__c,score_review_finish_rate__c,score_reviews__c FROM Account]); 
	}
	global void execute(Database.BatchableContext ctx,list<Account> list_acc)
	{
		for(Account acc : list_acc)
		{
			//score(Purchase Times)=[Purchase Times]/[max(Purchase Times))] 
		    if(acc.purchase_times__c != null && timemax != null && timemax != 0)
		    {
		        acc.score_purchase_times__c=acc.purchase_times__c/timemax;
		    }
		    else
		    {
		        acc.score_purchase_times__c=0;
		    }
		    //score(Purchase Products)=[Purchase Products)]/[max(Purchase Products)] 
		    if(acc.purchase_products__c != null && promax != null && promax != 0)
		    {
		        acc.score_purchase_products__c=acc.purchase_products__c/promax;
		    }
		    else
		    {
		        acc.score_purchase_products__c=0;
		    }
		    //score(Purchase Total Amount)=[Purchase Total Amount]/[max(Purchase Total Amount)]  
		    if(acc.purchase_total_amount__c != null && amomax != null && amomax != 0)
		    {
		        acc.score_purchase_total_amount__c=acc.purchase_total_amount__c/amomax;
		    }
		    else
		    {
		        acc.score_purchase_total_amount__c=0;
		    }
		    //score(Avg Order Price)=[Avg Order Price]/[max(Avg Order Price)]  
		    if(acc.avg_order_price__c != null && opmax != null && opmax != 0)
		    {
		        acc.score_avg_order_price__c=acc.avg_order_price__c/opmax;
		    }
		    else
		    {
		        acc.score_avg_order_price__c=0;
		    }
		    //score(Reviews)=[Reviews]/[max(Reviews)] 
		    if(acc.reviews__c != null && rvmax != null && rvmax != 0)
		    {
		        acc.score_reviews__c=acc.reviews__c/rvmax;
		    }
		    else
		    {
		        acc.score_reviews__c=0;
		    }
		    //score(Avg Review Star)=[Avg Review Star]/[max(Avg Review Star)] 
		    if(acc.avg_review_star__c != null && starmax != null && starmax != 0)
		    {
		        acc.score_avg_review_star__c=acc.avg_review_star__c/starmax;
		    }
		    else
		    {
		        acc.score_avg_review_star__c=0;
		    }
		    //score(Mails Open rate)=[Mails Open rate]/[max(Mails Open rate)]  
		    if(acc.mails_open_rate__c != null && openmax != null && openmax != 0)
		    {
		        acc.score_mails_open_rate__c=acc.mails_open_rate__c/openmax;
		    }
		    else
		    {
		        acc.score_mails_open_rate__c=0;
		    }
		    //score(Mails click rate)=[Mails click rate]/[max(Mails click rate)] 
		    if(acc.mails_click_rate__c != null && clickmax != null && clickmax != 0)
		    {
		        acc.score_mails_click_rate__c=acc.mails_click_rate__c/clickmax;
		    }
		    else
		    {
		        acc.score_mails_click_rate__c=0;
		    }
		    //score(Reviewer Helpful)=[Reviewer Helpful]/[max(Reviewer Helpful)]   
		    if(acc.reviewer_helpful__c != null && helpmax != null && helpmax != 0)
		    {
		        acc.score_reviewer_helpful__c=acc.reviewer_helpful__c/helpmax;
		    }
		    else
		    {
		        acc.score_reviewer_helpful__c=0;
		    }
		    //score(Reviewer Helpful Rating)=[Reviewer Helpful Rating]/[max(Reviewer Helpful Rating)]
		    if(acc.reviewer_helpful_rating__c != null && hfratemax != null && hfratemax != 0)
		    {
		        acc.score_reviewer_helpful_rating__c=acc.reviewer_helpful_rating__c/hfratemax;
		    }
		    else
		    {
		        acc.score_reviewer_helpful_rating__c=0;
		    }
		    //score(Reviewer ranking)=[ max(Reviewer ranking) - Reviewer ranking]/[max(Reviewer ranking)] --- 0除外，即当运算结果为1时，值为0      
		    if(acc.reviewer_ranking__c != 0 && acc.reviewer_ranking__c != null && rankmax != null && rankmax != 0)
		    {
		        acc.score_reviewer_ranking__c=(rankmax - acc.reviewer_ranking__c)/rankmax;
		    }
		    else
		    {
		        acc.score_reviewer_ranking__c=0;
		    }
		    //score(Reviewer Avg Review Star)=[Reviewer Avg Review Star]/[max(Reviewer Avg Review Star)]  
		    if(acc.reviewer_avg_review_star__c != null && arsmax != null && arsmax != 0)
		    {
		        acc.score_reviewer_avg_review_Star__c=acc.reviewer_avg_review_star__c/arsmax;
		    }
		    else
		    {
		        acc.score_reviewer_avg_review_Star__c=0;
		    }
		    //score(Review Accept rate)=[Review Accept rate]/[max(Review Accept rate)] 
		    if(acc.review_accept_rate__c != null && accmax != null && accmax != 0)
		    {
		        acc.score_review_accept_rate__c=acc.review_accept_rate__c/accmax;
		    }
		    else
		    {
		        acc.score_review_accept_rate__c=0;
		    }
		    //score(Review Finish rate)=[Review Finish rate]/[max(Review Finish rate)]  
		    if(acc.review_finish_rate__c != null && finishmax != null && finishmax != 0)
		    {
		        acc.score_review_finish_rate__c=acc.review_finish_rate__c/finishmax;
		    }
		    else
		    {
		        acc.score_review_finish_rate__c=0;
		    }
		    //score(Reviewer Avg Star For Sunvalley)=[Reviewer Avg Star For Sunvalley]/[max(Reviewer Avg Star For Sunvalley)] 
		    if(acc.reviewer_avg_star_for_sunvalley__c != null && asfsmax != null && asfsmax != 0)
		    {
		        acc.score_reviewer_avg_star_for_sunvalley__c=acc.reviewer_avg_star_for_sunvalley__c/asfsmax;
		    }
		    else
		    {
		        acc.score_reviewer_avg_star_for_sunvalley__c=0;
		    }
		    //score(Reviewer Feedback Rate)=[max(Reviewer Feedback Rate) - Reviewer Feedback Rate]/max(Reviewer Feedback Rate) --- 0除外，即当运算结果为1时，值为0
		    if(acc.reviewer_feedback_rate__c != 0 && acc.reviewer_feedback_rate__c != null && rfrmax != null && rfrmax != 0)
		    {
		        acc.score_reviewer_feedback_rate__c=(rfrmax - acc.reviewer_feedback_rate__c)/rfrmax;
		    }
		    else
		    {
		        acc.score_reviewer_feedback_rate__c=0;
		    }
		}
		update list_acc;
	}
    global void finish(Database.BatchableContext ctx)
    {
     	  
    }
}