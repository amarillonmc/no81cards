local m=15004042
local cm=_G["c"..m]
cm.name="异再神溶解"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15004042+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.r1filter(c,tp)
	local g=Duel.GetMatchingGroup(cm.r2filter,1-tp,LOCATION_MZONE,0,nil)
	return c:IsSetCard(0x5f3f) and c:IsReleasable() and g:CheckWithSumGreater(Card.GetLevel,c:GetLevel(),1,99)
end
function cm.r2filter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.r1filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local ag=Duel.SelectMatchingCard(tp,cm.r1filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local lv=ag:GetFirst():GetLevel()
	if ag:GetFirst():IsFacedown() then Duel.ConfirmCards(1-tp,ag:GetFirst()) end
	if Duel.Release(ag:GetFirst(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local g=Duel.GetMatchingGroup(cm.r2filter,1-tp,LOCATION_MZONE,0,nil)
		local sg=g:SelectWithSumGreater(1-tp,Card.GetLevel,ag:GetFirst():GetLevel(),1,99)
		if sg and sg:GetCount()>0 then
			Duel.Release(sg,REASON_EFFECT)
		end
	end
end