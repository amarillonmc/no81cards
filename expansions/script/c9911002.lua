--沧海姬 伊阿珀托斯
function c9911002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911002)
	e1:SetCondition(c9911002.spcon1)
	e1:SetCost(c9911002.spcost)
	e1:SetTarget(c9911002.sptg)
	e1:SetOperation(c9911002.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911002.spcon2)
	c:RegisterEffect(e2)
	--change attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9911002.attcon)
	e3:SetTarget(c9911002.atttg)
	e3:SetOperation(c9911002.attop)
	c:RegisterEffect(e3)
end
function c9911002.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911002.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911002.cfilter(c,tp,mc)
	local b1=c:IsLocation(LOCATION_HAND+LOCATION_MZONE)
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.IsPlayerAffectedByEffect(tp,9911013)
		and Duel.GetFlagEffect(tp,9911013)==0 and mc:IsLevelAbove(0) and c:IsLevelAbove(mc:GetLevel()+1)
	return (b1 or b2) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c9911002.attfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9911002.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,c,tp,c)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,1,nil)
	local label=0
	if rg:IsExists(c9911002.attfilter,1,nil) then label=1 end
	if rg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
		Duel.RegisterFlagEffect(tp,9911013,RESET_PHASE+PHASE_END,0,0)
	end
	e:SetLabel(label)
	Duel.SendtoGrave(rg,REASON_RELEASE+REASON_COST)
end
function c9911002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end
function c9911002.thfilter(c)
	return c:IsSetCard(0x6954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9911002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c9911002.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911002,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9911002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c9911002.attcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9911002.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_EARTH) end
end
function c9911002.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
