--绝望与熔解的抉择
function c9910919.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910919.condition)
	e1:SetCost(c9910919.cost)
	e1:SetTarget(c9910919.target)
	e1:SetOperation(c9910919.activate)
	c:RegisterEffect(e1)
end
function c9910919.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9910919.cfilter(c,tp)
	return aux.IsCodeListed(c,9910871) and (c:IsControler(tp) or c:IsFaceup())
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9910919.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910919.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c9910919.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c9910919.setfilter(c,tp,code)
	return c:IsCode(code) and c:IsSSetable() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910919.chkfilter(c)
	return not c:IsAbleToRemove()
end
function c9910919.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910919.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,9910911)
		and Duel.IsExistingMatchingCard(c9910919.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,9910906)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil)
		and not Duel.IsExistingMatchingCard(c9910919.chkfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910919.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910919.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,tp,9910911)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910919.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,tp,9910906)
	if #g1==0 or #g2==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if #sg1==0 then return end
	Duel.ConfirmCards(1-tp,sg1)
	local tc=sg1:RandomSelect(1-tp,1):GetFirst()
	local code=0
	local res=Duel.SSet(tp,tc)
	sg1:RemoveCard(tc)
	Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
	if res==0 then return end
	if tc:IsCode(9910911) then
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_PENDULUM)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		end
	end
	if tc:IsCode(9910906) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
