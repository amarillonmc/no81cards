--陷阵营帐
function c9330018.initial_effect(c)
	c:EnableCounterPermit(0x2c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(c9330018.actcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf93))
	e2:SetValue(c9330018.efilter)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c9330018.accon)
	e3:SetOperation(c9330018.acop)
	c:RegisterEffect(e3)
	--activate field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9330018,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,9330018)
	e4:SetCondition(c9330018.accon2)
	e4:SetTarget(c9330018.actg2)
	e4:SetOperation(c9330018.acop2)
	c:RegisterEffect(e4)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9330018,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCountLimit(1,9330018)
	e5:SetCost(c9330018.thcost)
	e5:SetTarget(c9330018.tdtg)
	e5:SetOperation(c9330018.tdop)
	c:RegisterEffect(e5)
end
function c9330018.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==1
end
function c9330018.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_FIELD)
end
function c9330018.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsSetCard(0xaf93)
end
function c9330018.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9330018.cfilter,1,nil,tp)
end
function c9330018.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9330018.cfilter,1,nil) then
		e:GetHandler():AddCounter(0x2c,1)
	end
end
function c9330018.accon2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c9330018.filter(c,tp)
	return c:IsSetCard(0xaf93) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c9330018.thfilter(c,tp)
	return c:IsSetCard(0xaf93) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9330018.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
			return Duel.IsExistingMatchingCard(c9330018.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp)
			or Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,0,1,nil) 
			and Duel.IsExistingMatchingCard(c9330018.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9330018,0))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9330018.acop2(e,tp,eg,ep,ev,re,r,rp)
	b=Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,0,1,nil)
	if b and Duel.IsExistingMatchingCard(c9330018.thfilter,tp,LOCATION_DECK,0,1,nil,tp) and (not Duel.IsExistingMatchingCard(c9330018.filter,tp,LOCATION_DECK,0,1,nil) or Duel.SelectYesNo(tp,aux.Stringid(9330018,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9330018.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330018.filter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c9330018.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x2c,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x2c,2,REASON_COST)
end
function c9330018.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9330018,1))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9330018.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end