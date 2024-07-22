--天垣修正者 太一
function c67200941.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--apply
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200941,0))
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_PZONE)
	--e0:SetCountLimit(1,67200941)
	e0:SetCondition(c67200941.opcon)
	e0:SetTarget(c67200941.optg)
	e0:SetOperation(c67200941.opop)
	c:RegisterEffect(e0)
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200941,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(2,67200941)
	e1:SetCondition(c67200941.pspcon)
	e1:SetTarget(c67200941.pstg)
	e1:SetOperation(c67200941.psop)
	c:RegisterEffect(e1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200941,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	--e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(2,67200941)
	e1:SetCost(c67200941.thcost)
	e1:SetTarget(c67200941.thtg)
	e1:SetOperation(c67200941.thop)
	c:RegisterEffect(e1)	
end
function c67200941.cfilter1(c)
	return c:IsFaceup() 
end
function c67200941.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200941.cfilter1,1,nil)
end
function c67200941.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c67200941.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
--
function c67200941.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and bit.band(loc,LOCATION_PZONE)==LOCATION_PZONE and rc:IsSetCard(0x67a) and not rc:IsCode(67200941))
end
function c67200941.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200941.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)))
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(67200941,3)},{b2,1152})
		if op==1 then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		if op==2 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c67200941.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function c67200941.thfilter(c)
	return c:IsSetCard(0xc67a) and c:IsAbleToHand() and not c:IsCode(67200941)
end
function c67200941.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200941.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200941.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200941.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
