--天垣修正者 澄心
function c67200943.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:SetSPSummonOnce(67200943)
	--apply
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200943,0))
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_PZONE)
	--e0:SetCondition(c67200943.opcon)
	e0:SetTarget(c67200943.optg)
	e0:SetOperation(c67200943.opop)
	c:RegisterEffect(e0)
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200943,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c67200943.pspcon)
	e1:SetTarget(c67200943.pstg)
	e1:SetOperation(c67200943.psop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200943,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e2:SetCountLimit(1,67200943)
	e2:SetCost(c67200943.thcost)
	e2:SetOperation(c67200943.thop)
	c:RegisterEffect(e2)	
end
function c67200943.cfilter1(c)
	return c:IsFaceup() 
end
function c67200943.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200943.cfilter1,1,nil)
end
function c67200943.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c67200943.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
--
function c67200943.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return (re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and bit.band(loc,LOCATION_PZONE)==LOCATION_PZONE and rc:IsSetCard(0x67a) and not rc:IsCode(67200943))
end
function c67200943.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200943.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)))
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(67200943,3)},{b2,1152})
		if op==1 then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		if op==2 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c67200943.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function c67200943.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(c67200943.thop1)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	Duel.RegisterEffect(e1,tp)
end
function c67200943.filter(c)
	return c:IsSetCard(0xc67a) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function c67200943.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,67200943)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200943.filter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
