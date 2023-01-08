--末界星灾
function c9910669.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910669.condition)
	e1:SetCost(c9910669.cost)
	e1:SetTarget(c9910669.target)
	e1:SetOperation(c9910669.activate)
	c:RegisterEffect(e1)
end
function c9910669.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and Duel.IsChainNegatable(ev)
end
function c9910669.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9910669.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttack(0) and c:IsDefense(3000)
		and c:IsAbleToGrave() and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup())
end
function c9910669.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return (not rc:IsRelateToEffect(re) or rc:IsAbleToDeck())
		and Duel.IsExistingMatchingCard(c9910669.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)
	if rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c9910669.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re)
		and Duel.SendtoDeck(rc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local res=rc:IsLocation(LOCATION_DECK) and rc:IsControler(1-tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9910669.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			if tc:IsPreviousLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9910669,0)) then
				Duel.BreakEffect()
				local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
				Duel.Destroy(g1,REASON_EFFECT)
			end
			if tc:IsPreviousLocation(LOCATION_DECK) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9910669,1)) then
				Duel.BreakEffect()
				if res then Duel.ShuffleDeck(1-tp) end
				local g2=Duel.GetDecktopGroup(1-tp,1)
				Duel.DisableShuffleCheck()
				Duel.Destroy(g2,REASON_EFFECT)
			end
			if tc:IsPreviousLocation(LOCATION_MZONE) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9910669,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g3=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.Destroy(g3,REASON_EFFECT)
			end
		end
	end
end
