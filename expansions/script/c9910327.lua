--神树勇者的满开
function c9910327.initial_effect(c)
	--act field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910327,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910327+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(c9910327.target1)
	e1:SetOperation(c9910327.activate1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910327,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9910327+EFFECT_COUNT_CODE_OATH)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c9910327.condition2)
	e2:SetTarget(c9910327.target2)
	e2:SetOperation(c9910327.activate2)
	c:RegisterEffect(e2)
end
function c9910327.tffilter(c,tp)
	return c:IsCode(9910307) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c9910327.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910327.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c9910327.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910327.tffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if #tg==0 then return end
	local tc=tg:GetFirst()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if not Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9910327.efilter)
	e1:SetOwnerPlayer(tp)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1,true)
end
function c9910327.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function c9910327.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(9910307,PLAYER_ALL,LOCATION_FZONE)
end
function c9910327.synfilter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c9910327.synfilter2,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,e,tp,c)
end
function c9910327.synfilter2(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	local b1=c:IsLocation(LOCATION_HAND)
	local b2=c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0 and c:GetSequence()<5
	return (b1 or b2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
end
function c9910327.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910327.synfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910327.synfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910327.synfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910327.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c9910327.synfilter2,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if not sc or not Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	sc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	if not tc:IsRelateToEffect(e) then return end
	Duel.AdjustAll()
	local mg=Group.FromCards(tc,sc)
	if mg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,tg:GetFirst(),nil,mg)
	end
end
