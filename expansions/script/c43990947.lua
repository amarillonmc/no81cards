--象征世界的定制师
function c43990947.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)--
	e1:SetDescription(aux.Stringid(43990947,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,43990947)
	e1:SetCost(c43990947.spcost)
	e1:SetTarget(c43990947.sptg)
	e1:SetOperation(c43990947.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c43990947.spcon)
	c:RegisterEffect(e2)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,43990947+1000)
	e4:SetOperation(c43990947.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function c43990947.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,43990948)~=nil and c:IsOriginalSetCard(0x3511) and c:IsSummonableCard()
end
function c43990947.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetMZoneCount(tp,e:GetHandler())>0 end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c43990947.spfilter(c,e,tp)
	return c:IsSetCard(0x3511) and not c:IsCode(43990947) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(4)
end
function c43990947.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:IsCostChecked() or Duel.GetMZoneCount(tp)>0)
		and Duel.IsExistingMatchingCard(c43990947.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c43990947.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local ft=not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp)>=2 and 2 or 1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43990947.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c43990947.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c43990947.spscon)
	e1:SetOperation(c43990947.spsop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c43990947.spsfilter(c,e,tp)
	return c:IsSetCard(0x3511) and not c:IsCode(43990947) and (c:IsAbleToHand() or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and aux.NecroValleyFilter()(c) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER)
end
function c43990947.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c43990947.spsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990947)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c43990947.spsfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	if sc:IsAbleToHand() and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	else
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
