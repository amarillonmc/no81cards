--灵刀姬 零衣pendulum
function c60001013.initial_effect(c)
	 aux.EnablePendulumAttribute(c)
	--tohand(p1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60001013,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,60001013)
	e3:SetTarget(c60001013.target)
	e3:SetOperation(c60001013.operation)
	c:RegisterEffect(e3)
	--spsummon(p2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001013,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,60001013)
	e1:SetCondition(c60001013.spcon)
	e1:SetTarget(c60001013.sptg)
	e1:SetOperation(c60001013.spop)
	c:RegisterEffect(e1)
	--spsummon(m1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001013,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,90001013)
	e1:SetCost(c60001013.spcost1)
	e1:SetTarget(c60001013.sptg1)
	e1:SetOperation(c60001013.spop1)
	c:RegisterEffect(e1)
	--spsummon(m2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001013,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e2:SetCountLimit(1,90001013)
	e2:SetCondition(c60001013.spcon2)
	e2:SetTarget(c60001013.sptg2)
	e2:SetOperation(c60001013.spop2)
	c:RegisterEffect(e2)

end
function c60001013.filter(c)
	return c:IsSetCard(0x624) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60001013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001013.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60001013.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60001013.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60001013.spfil(c)
	return c:GetSequence()<5
end
function c60001013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60001013.spfil,tp,LOCATION_MZONE,0,1,nil)
end
function c60001013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c60001013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60001013.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c60001013.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x1624) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c60001013.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001013.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60001013.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60001013.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
end
function c60001013.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0
		and c:IsPreviousSetCard(0x1624) and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c60001013.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001013.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c60001013.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60001013.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
