--甜心机仆的残波
Duel.LoadScript("c9910550.lua")
function c9910557.initial_effect(c)
	--flag
	Txjp.AddTgFlag(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910557)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910557.target)
	e1:SetOperation(c9910557.activate)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c9910557.actcon)
	e2:SetOperation(c9910557.actop)
	c:RegisterEffect(e2)
end
function c9910557.tdfilter(c)
	return c:IsSetCard(0x3951) and c:IsAbleToDeck()
end
function c9910557.filter1(c,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN)
end
function c9910557.filter2(c,id)
	return c:GetTurnID()<id and not c:IsReason(REASON_RETURN)
end
function c9910557.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910557.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function c9910557.fselect(g,id)
	return g:FilterCount(c9910557.filter1,nil,id)<2 and g:FilterCount(c9910557.filter2,nil,id)<2
		and g:FilterCount(Card.IsReason,nil,REASON_RETURN)<2
end
function c9910557.activate(e,tp,eg,ep,ev,re,r,rp)
	local id=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910557.tdfilter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c9910557.fselect,false,1,3,id)
	if sg and sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
		local oc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if oc==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local og=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,oc,nil)
		Duel.HintSelection(og)
		Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
	end
end
function c9910557.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c9910557.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9910557)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3951))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,9910557,RESET_PHASE+PHASE_END,0,1)
end
