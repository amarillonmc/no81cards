local m=31400084
local cm=_G["c"..m]
cm.name="熊极天进动"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(16471775)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+100000000)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.filter(c)
	local con1=c:IsAbleToHand()
	local con2=c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
	return c:IsSetCard(0x163) and (con1 or con2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc1 and tc1:IsType(TYPE_SPELL+TYPE_TRAP) and tc1:IsSSetable() and (not tc1:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.SSet(tp,tc1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		if tc1:IsType(TYPE_QUICKPLAY) then
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		else
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		end
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCondition(cm.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
	else
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc2 and tc2:IsType(TYPE_SPELL+TYPE_TRAP) and tc2:IsSSetable() and (not tc2:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.SSet(tp,tc2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		if tc2:IsType(TYPE_QUICKPLAY) then
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		else
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		end
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCondition(cm.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
	else
		Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc2)
	end
end
function cm.actconfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x163)
end
function cm.actcon(e)
	return Duel.GetMatchingGroupCount(cm.actconfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==0
end