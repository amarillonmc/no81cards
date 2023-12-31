--Speedster Supersonic
function c31034015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,31034015+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c31034015.condition)
	e1:SetCost(c31034015.cost)
	e1:SetTarget(c31034015.target)
	e1:SetOperation(c31034015.activate)
	c:RegisterEffect(e1)
end

function c31034015.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE
		and Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0
end

function c31034015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 2, c) end
	Duel.DiscardHand(tp, Card.IsDiscardable, 2, 2, REASON_COST+REASON_DISCARD)
end 

function c31034015.spfilter1(c, e, tp)
	return c:IsCode(31034001) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function c31034015.spfilter2(c, e, tp)
	return c:IsSetCard(0x892) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function c31034015.syfilter(e, tp)
	local g1=Duel.GetMatchingGroup(c31034015.spfilter1, tp, LOCATION_DECK, 0, nil, e, tp)
	local g2=Duel.GetMatchingGroup(c31034015.spfilter2, tp, LOCATION_DECK, 0, nil, e, tp)
	--Duel.Draw(tp, 1, REASON_EFFECT)
	--return true
	for tc1 in aux.Next(g1) do
		for tc2 in aux.Next(g2) do
			local g=Group.CreateGroup()
			g:AddCard(tc1)
			g:AddCard(tc2)
			--Duel.Draw(tp, 1, REASON_EFFECT)
			if Duel.IsExistingMatchingCard(Card.IsSynchroSummonable, tp, LOCATION_EXTRA, 0, 1, nil, nil, g) then
				--Duel.Draw(tp, 1, REASON_EFFECT)
				return true end
		end
	end
	return false
end

function c31034015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 1 and not Duel.IsPlayerAffectedByEffect(tp, 59822133)
		and Duel.IsPlayerCanSpecialSummonCount(tp, 2) and c31034015.syfilter(e, tp)
		and Duel.IsExistingMatchingCard(c31034015.spfilter1, tp, LOCATION_DECK, 0, 1, nil, e, tp)
		and Duel.IsExistingMatchingCard(c31034015.spfilter2, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 3, tp, LOCATION_DECK+LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetTurnPlayer() == tp then
		Duel.SetChainLimit(aux.FALSE)
	end
end

function c31034015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp, 59822133) or Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 then return end
	if not Duel.IsExistingMatchingCard(c31034015.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		or not Duel.IsExistingMatchingCard(c31034015.spfilter2, tp, LOCATION_DECK, 0, 1, nil, e, tp) then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg1=Duel.SelectMatchingCard(tp, c31034015.spfilter1, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	--local tun=sg:GetFirst()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg2=Duel.SelectMatchingCard(tp, c31034015.spfilter2, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	sg1:Merge(sg2)
	for tc in aux.Next(sg1) do
		Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable, tp, LOCATION_EXTRA, 0, nil, nil, sg1)
	if sg:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local pg=sg:Select(tp, 1, 1, nil)
		Duel.SynchroSummon(tp, pg:GetFirst(), nil, sg1)
	end
end