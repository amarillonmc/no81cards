--人理之诗 心荡神驰的黄金剧场
function c22020140.initial_effect(c)
	aux.AddCodeList(c,22020130)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020140,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020140)
	e1:SetTarget(c22020140.target)
	e1:SetOperation(c22020140.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c22020140.tg)
	e2:SetValue(-900)
	c:RegisterEffect(e2)
	--coin result
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020140,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,22020141)
	e3:SetCondition(c22020140.coincon1)
	e3:SetOperation(c22020140.coinop1)
	c:RegisterEffect(e3)
end
function c22020140.filter(c)
	return c:IsCode(22020130) and c:IsAbleToHand()
end
function c22020140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020140.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020140.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020140.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020140.tg(e,c)
	return c:IsFaceup() and c:IsDisabled()
end
function c22020140.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 then
		e:SetLabelObject(re)
		return true
	else return false end
end
function c22020140.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22020140.coincon2)
	e1:SetOperation(c22020140.coinop2)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c22020140.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c22020140.coinop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22020140)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	end
	Duel.SetCoinResult(table.unpack(res))
end
