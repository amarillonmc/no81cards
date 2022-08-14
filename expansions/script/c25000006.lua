local m=25000006
local cm=_G["c"..m]
cm.name="在顶层楼座之上"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if Duel.IsChainDisablable(0) and hg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,1))
		local sg=hg:Select(1-tp,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.NegateEffect(0)
		return
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if Duel.SendtoHand(g,1-tp,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND),REASON_EFFECT)
	end
end
