--超重巨人 大太法师-T
function c98920349.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9a),aux.NonTuner(Card.IsSetCard,0x9a),1)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920349,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c98920349.setcon)
	e1:SetCost(c98920349.cost)
	e1:SetTarget(c98920349.target)
	e1:SetOperation(c98920349.activate)
	c:RegisterEffect(e1)
end
function c98920349.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c98920349.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98920349.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c98920349.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98920349.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetChainLimit(c98920349.climit)
end
function c98920349.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98920349,1))
		local tg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		local tc=tg:GetFirst()
		if tc and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)) then
			Duel.SSet(tp,tc)
		end
		Duel.ShuffleHand(1-tp)
	end
end
function c98920349.climit(e,lp,tp)
	return lp==tp
end