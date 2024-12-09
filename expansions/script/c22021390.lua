--人理之诗 吾枪通达万物
function c22021390.initial_effect(c)
	aux.AddCodeList(c,22021380)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22021390)
	e1:SetCost(c22021390.cost)
	e1:SetCondition(c22021390.spcon)
	e1:SetTarget(c22021390.target)
	e1:SetOperation(c22021390.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetCondition(c22021390.condition)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--coin result
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021390,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22021390)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c22021390.coincon1)
	e3:SetOperation(c22021390.coinop1)
	c:RegisterEffect(e3)
end
function c22021390.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22021390.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function c22021390.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22021390.cfilter,1,nil,1-tp)
end
function c22021390.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021390,0))
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22021390.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c22021390.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22021390.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22021390.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c22021390.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22021390.desfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.SelectOption(tp,aux.Stringid(22021390,1))
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function c22021390.cfilter(c)
	return c:IsFaceup() and c:IsCode(22021380)
end
function c22021390.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 and Duel.IsExistingMatchingCard(c22021390.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		e:SetLabelObject(re)
		return true
	else return false end
end
function c22021390.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22021390.coincon2)
	e1:SetOperation(c22021390.coinop2)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c22021390.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c22021390.coinop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22021390)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	end
	Duel.SetCoinResult(table.unpack(res))
end
