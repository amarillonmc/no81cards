--红真之眼 尼库拉的夜
function c11210690.initial_effect(c)
	aux.AddCodeList(c,11210685)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11210690.target)
	e1:SetOperation(c11210690.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11210690)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11210690.sptg)
	e2:SetOperation(c11210690.spop)
	c:RegisterEffect(e2)
end
function c11210690.thfilter(c,chk)
	return c:IsRace(RACE_ILLUSION) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(6) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c11210690.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckReleaseGroup(tp,nil,1,nil,tp) and Duel.IsExistingMatchingCard(c11210690.thfilter,tp,LOCATION_DECK,0,1,nil,0) and Duel.GetFlagEffect(tp,11210690)==0
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x30,0x30,nil)
	local b2=g:IsExists(Card.IsControler,1,nil,0) and g:IsExists(Card.IsControler,1,nil,1) and Duel.GetFlagEffect(tp,11210691)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(11210690,0)},
		{b2,aux.Stringid(11210690,1)})
	e:SetLabel(op)
	if op==1 then
		--cost
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil,tp)
		Duel.Release(g,REASON_COST)
		--
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,11210690,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
		Duel.RegisterFlagEffect(tp,11210691,RESET_PHASE+PHASE_END,0,1)
	end
end
function c11210690.gcheck(g)
	return g:FilterCount(Card.IsControler,nil,0)==g:FilterCount(Card.IsControler,nil,1)
end
function c11210690.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c11210690.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			if tc:IsCode(11210685) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(11210690,2)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x30,0x30,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,c11210690.gcheck,false,2,10)
		Duel.HintSelection(sg)
		if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==10 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c11210690.spfilter(c,e,tp,chk)
	return c:IsLevelAbove(6) and c:IsRace(RACE_ILLUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx() and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_MONSTER)
end
function c11210690.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c11210690.spfilter,tp,0x30,0,1,nil,e,tp,0)
	end--Duel.IsPlayerAffectedByEffect(tp,59822133)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end
function c11210690.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c11210690.spfilter,tp,0x30,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
