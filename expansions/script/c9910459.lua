--欢欣激奏的韶光
function c9910459.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910459.target)
	e1:SetOperation(c9910459.operation)
	c:RegisterEffect(e1)
end
function c9910459.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,5)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910459.filter(c,tp)
	return c:GetSequence()>=5 and c:IsControler(1-tp) and c:IsAbleToDeck()
end
function c9910459.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,5)
	local g2=Duel.GetDecktopGroup(1-tp,5)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	if Duel.SendtoGrave(g1,REASON_EFFECT)==0 then return end
	local g3=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local g4=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	if g3:GetCount()>0 and g3:GetClassCount(Card.GetCode)~=g3:GetCount() then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		Duel.DisableShuffleCheck(false)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	elseif g4:GetCount()>0 and g4:GetClassCount(Card.GetCode)~=g4:GetCount() then
		local sg=Group.CreateGroup()
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910459,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,2,nil)
			Duel.HintSelection(sg1)
			sg:Merge(sg1)
		end
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910459,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
			Duel.HintSelection(sg2)
			sg:Merge(sg2)
		end
		if sg:GetCount()>0 then
			Duel.DisableShuffleCheck(false)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
