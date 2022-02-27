--珊海环的海洋候 维帕珥
function c67200529.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c67200529.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x675),1,1)
	c:EnableReviveLimit()  
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200529,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c67200529.nethcon)
	e1:SetTarget(c67200529.nethtg)
	e1:SetOperation(c67200529.nethop)
	c:RegisterEffect(e1)	   
end
function c67200529.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x675)
end
--
function c67200529.nethcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=3
end
function c67200529.nethtg(e,tp,eg,ep,ev,re,r,rp,chk)
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
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,dg,dg:GetCount(),0,0)
end
function c67200529.nethop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if (te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER))
			and Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
			tc:CancelToGrave()
			dg:AddCard(tc)
		end
	end
	Duel.SendtoHand(dg,tp,REASON_EFFECT)
end

