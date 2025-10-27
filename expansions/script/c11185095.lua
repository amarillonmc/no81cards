--星绘·鄢暨
function c11185095.initial_effect(c)
	aux.AddCodeList(c,0x452)
	c:EnableCounterPermit(0x452)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pzone
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,11185095)
	e1:SetCondition(c11185095.pccon)
	e1:SetTarget(c11185095.pctg)
	e1:SetOperation(c11185095.pcop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11185095+1)
	e2:SetTarget(c11185095.thtg)
	e2:SetOperation(c11185095.thop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,11185095+2)
	e3:SetTarget(c11185095.sptg2)
	e3:SetOperation(c11185095.spop2)
	c:RegisterEffect(e3)
end
function c11185095.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function c11185095.pcfilter(c)
	return c:GetOriginalType()&(TYPE_PENDULUM)>0 and not c:IsForbidden() and c:IsSetCard(0x452)
		and not c:IsLocation(LOCATION_PZONE+LOCATION_FZONE)
end
function c11185095.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c11185095.pcfilter,tp,0x38,0,1,nil) end
end
function c11185095.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11185095.pcfilter),tp,0x38,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c11185095.thfilter(c)
	return c:IsSetCard(0x452) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c11185095.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185095.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11185095.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11185095.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11185095.tfilter(c,sc,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x452)
end
function c11185095.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c11185095.tfilter,tp,LOCATION_ONFIELD,0,1,nil,c,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11185095.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c11185095.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil,c,tp)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			if c:IsCanAddCounter(0x452,1) and Duel.SelectYesNo(tp,aux.Stringid(11185095,0)) then
				Duel.BreakEffect()
				c:AddCounter(0x452,1)
			end
		end
	end
end