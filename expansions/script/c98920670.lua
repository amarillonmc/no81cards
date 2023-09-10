--黑羽-赫灼之帕尔希
function c98920670.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(nil),1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920670,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98920670)
	e1:SetCondition(c98920670.thcon)
	e1:SetTarget(c98920670.thtg)
	e1:SetOperation(c98920670.thop)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCost(c98920670.cost)
	e1:SetCondition(c98920670.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c98920670.activate)
	c:RegisterEffect(e1)
end
function c98920670.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920670.thfilter(c,lv)
	return c:IsSetCard(0x33) and c:IsAbleToHand() and c:IsLevelBelow(lv)
end
function c98920670.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920670.thfilter,tp,LOCATION_DECK,0,1,nil,ct) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920670.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,c98920670.thfilter,tp,LOCATION_DECK,0,1,1,nil,ct)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(98920670,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(c98920670.estg)
		e1:SetLabel(g:GetFirst():GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98920670.estg(e,c)
	return c:IsCode(e:GetLabel())
end
function c98920670.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98920670.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c98920670.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end