--秘仪之宣判
function c79029509.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetCondition(c79029509.cocon)
	e2:SetOperation(c79029509.coop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79029509.discon)
	e3:SetTarget(c79029509.distg)
	e3:SetOperation(c79029509.disop)
	c:RegisterEffect(e3)
end
function c79029509.cocon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x5)
end
function c79029509.coop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c79029509[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(79029509,0)) then
	Duel.Hint(HINT_CARD,0,79029509)
	local cn=Duel.AnnounceCoin(tp)
	if cn==60 then
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	Duel.SetCoinResult(table.unpack(res))
	end
	else
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=0
	end
	Duel.SetCoinResult(table.unpack(res))
end
end
end
function c79029509.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function c79029509.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,eg,1,0,0)
end
function c79029509.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xc=Duel.TossCoin(tp,1)
	if xc==0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	else 
	Duel.NegateActivation(ev)
	Duel.Destroy(eg,REASON_EFFECT)
end
end
