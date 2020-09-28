local m=82228620
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon rule  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)  
	--pierce  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e2)  
end
function cm.spfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x3299) and c:IsType(0x6)
end  
function cm.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD,0,1,nil)  
end  