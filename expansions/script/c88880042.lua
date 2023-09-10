--神蚀创痕-瓦尔基里·乌拉诺斯
function c88880042.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c88880042.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc06),true)  
end
function c88880042.matfilter(c)
	return c:IsFusionSetCard(0xc06) and c:IsLevelAbove(8)
end