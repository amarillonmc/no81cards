--炭酸装姬·可乐 
function c11526309.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,11526301),nil,nil,aux.FilterBoolFunction(aux.TRUE),1,99)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,11526309)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11526309.condition)
	e1:SetCost(c11526309.cost)
	e1:SetTarget(c11526309.target)
	e1:SetOperation(c11526309.activate)
	c:RegisterEffect(e1)
end
c11526309.SetCard_Carbonic_Acid_Girl=true 
--
function c11526309.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=3
end
function c11526309.costfilter(c)
	return c.SetCard_Carbonic_Acid_Girl and c:IsAbleToGraveAsCost() 
end
function c11526309.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	if chk==0 then return Duel.IsExistingMatchingCard(c11526309.costfilter,tp,LOCATION_DECK,0,chain,c) end
	local g2=Duel.GetMatchingGroup(c11526309.costfilter,tp,LOCATION_DECK,0,nil)
	local tc=g2:Select(tp,chain,chain,nil)
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
end
function c11526309.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c11526309.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if (te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER))
			and Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
			dg:AddCard(tc)
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end

