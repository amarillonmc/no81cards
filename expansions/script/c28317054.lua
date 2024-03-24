--闪耀的绿宝石 绯田美琴
function c28317054.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--shhis pendulum return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28317054,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,28317054)
	e1:SetCondition(c28317054.recon)
	e1:SetTarget(c28317054.retg)
	e1:SetOperation(c28317054.reop)
	c:RegisterEffect(e1)
	--shhis spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28317054,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,38317054)
	e2:SetCondition(c28317054.spcon)
	e2:SetTarget(c28317054.sptg)
	e2:SetOperation(c28317054.spop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c28317054.thtg)
	e3:SetOperation(c28317054.thop)
	c:RegisterEffect(e3)
	--shhis pendulum check
	Duel.AddCustomActivityCounter(28317054,ACTIVITY_SPSUMMON,c28317054.counterfilter)
end
function c28317054.counterfilter(c)
	return not (c:IsSetCard(0x283) and c:IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c28317054.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(28317054,tp,ACTIVITY_SPSUMMON)>0
end
function c28317054.gthfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28317054.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28317054.gthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c28317054.reop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.SendtoHand(pg,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c28317054.gthfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c28317054.gthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_PZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c28317054.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x283) and c:IsFaceup()
end
function c28317054.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28317054.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c28317054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28317054.rmfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToGrave()
end
function c28317054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c28317054.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28317054,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=Duel.SelectMatchingCard(tp,c28317054.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c28317054.dthfilter(c)
	return c:IsSetCard(0x283) and (c:IsType(TYPE_MONSTER) or Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_PZONE,0,1,nil,28315848)) and c:IsAbleToHand()
end
function c28317054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28317054.dthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28317054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28317054.dthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
