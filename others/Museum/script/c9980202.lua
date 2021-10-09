--守护女神·Pish
function c9980202.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9980202.splimit)
	c:RegisterEffect(e2)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9980202)
	e2:SetCondition(c9980202.thcon)
	e2:SetTarget(c9980202.target)
	e2:SetOperation(c9980202.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c9980202.atkcon)
	e3:SetTarget(c9980202.atktg)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
end
function c9980202.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xbc8) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c9980202.scfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xbc8) and c:IsControler(tp)
end
function c9980202.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980202.scfilter,1,nil,tp)
end
function c9980202.filter(c)
	return c:IsSetCard(0xbc8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980202.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9980202.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980202.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980202.atkcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c9980202.atktg(e,c)
	return c:IsRace(RACE_FAIRY)
end