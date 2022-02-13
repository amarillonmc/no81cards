--黄昏刹那
local m=60000063
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--act in hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e5:SetCondition(cm.handcon)
	c:RegisterEffect(e5)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
--act in hand
function cm.handcon(e)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=15
end
--Effect 1
function cm.todeckfilter(c)
	return c:IsSetCard(0x62a) and c:IsAbleToDeck()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.todeckfilter,tp,LOCATION_GRAVE,0,3,nil) and e:GetHandler():GetFlagEffect(m)==0 and Duel.IsPlayerCanDraw(tp,1) end
	local g=Duel.GetMatchingGroup(cm.todeckfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEDOWN)~=0 then
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.todeckfilter),tp,LOCATION_GRAVE,0,3,3,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
			local og=Duel.GetOperatedGroup()
			if not og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then return end
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
	end
end
