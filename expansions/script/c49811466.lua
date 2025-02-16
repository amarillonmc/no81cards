--熔岩洞窟鳞蛇
function c49811466.initial_effect(c)
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetDescription(1164)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,49811466)
	e1:SetCondition(c49811466.syncon)
	e1:SetTarget(c49811466.syntg)
	e1:SetOperation(c49811466.synop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1152)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c49811466.spcon)
	e2:SetTarget(c49811466.sptg)
	e2:SetOperation(c49811466.spop)
	c:RegisterEffect(e2)
end
function c49811466.syncon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x39):GetClassCount(Card.GetCode)>=3
end
function c49811466.sfilter(c,tc)
	return c:IsSetCard(0x39) and c:IsSynchroSummonable(tc)
end
function c49811466.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811466.sfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c49811466.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c49811466.sfilter,tp,LOCATION_EXTRA,0,nil,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(sc)
		e1:SetDescription(aux.Stringid(49811466,0))
		e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetTarget(c49811466.tgtg)
		e1:SetOperation(c49811466.tgop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		sc:RegisterEffect(e1,true)
		if not sc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			sc:RegisterEffect(e2,true)
		end
		Duel.SynchroSummon(tp,sc,c)
	end
end
function c49811466.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_EXTRA,0,1,nil) end
end
function c49811466.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsLevel,nil,e:GetHandler():GetLevel())
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=tg:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(0x10) then
			Duel.Damage(1-tp,math.floor(tc:GetAttack()/2),REASON_EFFECT)
		end
	end
end
function c49811466.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
end
function c49811466.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811466.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c49811466.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c49811466.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c49811466.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c49811466.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
