--猩红血钻 卢西恩
function c79029169.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--Negate 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,79029169) 
	e2:SetCondition(c79029169.ngcon)
	e2:SetCost(c79029169.ngcost)
	e2:SetTarget(c79029169.ngtg)
	e2:SetOperation(c79029169.ngop)
	c:RegisterEffect(e2)
end
function c79029169.ngcon(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetCurrentChain()<3 then return false end
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false
end
function c79029169.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c79029169.nckfil(c)
	return not c:IsType(TYPE_FIELD) 
end
function c79029169.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) end  
	local x=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,0,0,0)
	if not Duel.IsExistingMatchingCard(c79029169.nckfil,tp,LOCATION_ONFIELD,0,1,nil) then 
	local ctype=0 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil) 
	local tc=g:GetFirst()
	while tc do
		for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if tc:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
		end
		tc=g:GetNext()
	end
	Duel.SetChainLimit(c79029169.chlimit(ctype))
	end
	Duel.Hint(24,0,aux.Stringid(79029169,0))
end
function c79029169.chlimit(ctype)
	return function(e,ep,tp)
		return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
	end
end
function c79029169.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel()
	local g=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
		g:AddCard(te:GetHandler())
		end
	end 
	local sg=g:Select(tp,1,x,nil) 
	local tc=sg:GetFirst()
	while tc do 
	tc:RegisterFlagEffect(79029169,RESET_CHAIN,0,1)
	tc=sg:GetNext()
	end
	for i=1,ev do   
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT) 
	if te:GetHandler():GetFlagEffect(79029169)~=0 then 
	Duel.NegateEffect(i)
	end
	end  
end







