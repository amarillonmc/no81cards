--神树精灵 先代化身
function c9910352.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910352)
	e1:SetCondition(c9910352.spcon)
	e1:SetTarget(c9910352.sptg)
	e1:SetOperation(c9910352.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910353)
	e2:SetTarget(c9910352.tgtg)
	e2:SetOperation(c9910352.tgop)
	c:RegisterEffect(e2)
end
function c9910352.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(9910307,PLAYER_ALL,LOCATION_FZONE)
end
function c9910352.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910352.sumfilter(c)
	return c:IsSetCard(0x956) and c:IsSummonable(true,nil)
end
function c9910352.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c9910352.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910352,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910352.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c9910352.tgfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function c9910352.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910352.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9910352.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR+RACE_PLANT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910352.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910352.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and tc:IsPreviousLocation(LOCATION_HAND) then
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910352.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910352,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910352.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910352.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_PLANT)) and c:IsLocation(LOCATION_EXTRA)
end
