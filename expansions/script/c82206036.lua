local m=82206036
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()  
	aux.AddFusionProcFun2(c,cm.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x129d),true) 
	--change pos  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetTarget(cm.postg)  
	e2:SetOperation(cm.posop)  
	c:RegisterEffect(e2)
	--destroy  
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(m,1)) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_DESTROY)   
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)   
	e3:SetTarget(cm.destg)  
	e3:SetOperation(cm.desop)  
	c:RegisterEffect(e3)		 
end
function cm.matfilter(c)  
	return c:IsFusionSetCard(0x129d) and c:IsLevelAbove(5)  
end
function cm.posfilter(c)  
	return c:IsFaceup() and c:IsCanChangePosition()  
end  
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)  
end  
function cm.posop(e,tp,eg,ep,ev,re,r,rp,chk)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)  
	local g=Duel.SelectMatchingCard(tp,cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then   
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)  
	end  
end
function cm.filter(c)  
	return c:IsFacedown()  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.Destroy(g,REASON_EFFECT)  
end 