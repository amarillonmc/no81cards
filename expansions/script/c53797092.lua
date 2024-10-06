local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and ((c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function s.filter(c,race,lv)
	return c:IsFaceup() and c:IsRace(race) and c:GetLevel()<lv
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		local g=eg:Filter(s.cfilter,nil,i)
		for ec in aux.Next(g) do
			local mg=Duel.GetMatchingGroup(s.filter,i,LOCATION_MZONE,0,nil,ec:GetPreviousRaceOnField(),ec:GetPreviousLevelOnField())
			for tc in aux.Next(mg) do
				if tc:GetFlagEffect(id)==0 then tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0,0) end
				local flag=tc:GetFlagEffectLabel(id)
				tc:SetFlagEffectLabel(id,flag+1)
			end
		end
	end
end
function s.tdfilter(c,tp)
	local ct=c:GetFlagEffectLabel(id) or 0
	return c:IsFaceup() and ct>0 and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tdfilter(chkc,tp) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local tdg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,Group.__add(g,tdg),1+#tdg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then g:AddCard(tc) end
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
