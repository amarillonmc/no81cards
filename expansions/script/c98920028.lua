--退炎星-雷剑齿 
function c98920028.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pierce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_PIERCE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x79))
	c:RegisterEffect(e0)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920028,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,98920028)
	e1:SetTarget(c98920028.tg)
	e1:SetOperation(c98920028.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--multiatk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920028,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920028.atkcon)
	e3:SetCost(c98920028.atkcost)
	e3:SetTarget(c98920028.atktg)
	e3:SetOperation(c98920028.atkop)
	c:RegisterEffect(e3)
end
function c98920028.filter(c)
	return c:IsSetCard(0x7c) and c:IsAbleToHand()
end
function c98920028.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920028.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920028.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920028.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920028.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c98920028.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c98920028.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if Duel.IsExistingMatchingCard(c98920028.filter2,tp,LOCATION_DECK,0,1,nil) then ft=ft+1 end
	if chk==0 then return Duel.IsExistingMatchingCard(c98920028.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		or (Duel.IsPlayerAffectedByEffect(tp,46241344) and ft>0) end
	if Duel.IsExistingMatchingCard(c98920028.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,46241344) or ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(46241344,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98920028.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c98920028.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c98920028.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end