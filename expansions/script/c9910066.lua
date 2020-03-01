--血亲的羁绊
function c9910066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910066.target)
	e1:SetOperation(c9910066.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910066.sptg)
	e2:SetOperation(c9910066.spop)
	c:RegisterEffect(e2)
end
function c9910066.synfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910066.synfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c9910066.synfilter2(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910066.synfilter3,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c9910066.synfilter3(c,mg)
	return c:IsSynchroSummonable(nil,mg) and c:IsRace(RACE_FAIRY)
end
function c9910066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910066.synfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsExistingTarget(c9910066.synfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910066.synfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c9910066.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910066.synfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		sc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
	local mg=Group.FromCards(tc,sc)
	local tg=Duel.GetMatchingGroup(c9910066.synfilter3,tp,LOCATION_EXTRA,0,nil,mg)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tsg=tg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,tsg:GetFirst(),nil,mg)
	end
end
function c9910066.cfilter(c)
	return c:IsAbleToRemove() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:GetLevel()>0
end
function c9910066.filter(c,e,tp)
	local g=Duel.GetMatchingGroup(c9910066.cfilter,tp,LOCATION_GRAVE,0,c)
	local sg=Group.CreateGroup()
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO)
		and c:IsAbleToExtra() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
		and g:IsExists(c9910066.selector,1,nil,tp,g,sg,c:GetLevel(),1)
end
function c9910066.selector(c,tp,g,sg,lv,i)
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<2 then
		flag=g:IsExists(c9910066.selector,1,nil,tp,g,sg,lv,i+1)
	else
		flag=sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0
			and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0
			and sg:CheckWithSumEqual(Card.GetLevel,lv,2,2)
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c9910066.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c9910066.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910066.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910066.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(c9910066.cfilter,tp,LOCATION_GRAVE,0,tc)
		local sg=Group.CreateGroup()
		if chk==0 then return g:IsExists(c9910066.selector,1,nil,tp,g,sg,tc:GetLevel(),1) end
		for i=1,2 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=g:FilterSelect(tp,c9910066.selector,1,1,nil,tp,g,sg,tc:GetLevel(),i)
			sg:Merge(g1)
			g:Sub(g1)
		end
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
