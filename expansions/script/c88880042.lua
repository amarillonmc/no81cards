--神蚀创痕-瓦尔基里·乌拉诺斯
function c88880042.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c88880042.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc06),true) 
 --  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c88880042.op)  
	c:RegisterEffect(e5)	
end
function c88880042.matfilter(c)
	return c:IsFusionSetCard(0xc06) and c:IsLevelAbove(8)
end
function c88880042.op(e,tp,eg,ep,ev,re,r,rp) 
	Debug.Message("天造之械皇，此即为编年之刻！")
	Debug.Message("神蚀融合！神蚀创痕-瓦尔基里·乌拉诺斯！")
end