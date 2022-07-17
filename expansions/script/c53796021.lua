local m=53796021
local cm=_G["c"..m]
cm.name="口服剂"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>1 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,nil,2,2,REASON_EFFECT+REASON_DISCARD)
end
