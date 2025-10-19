--人理之基 布狄卡
function c22024530.initial_effect(c)
	--coin result
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024530,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,22024530)
	e1:SetCost(c22024530.cost)
	e1:SetCondition(c22024530.coincon1)
	e1:SetOperation(c22024530.coinop1)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024530,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,22024531)
	e2:SetTarget(c22024530.atktg)
	e2:SetOperation(c22024530.atkop)
	c:RegisterEffect(e2)
end
function c22024530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22024530.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex and ct>1 then
		e:SetLabelObject(re)
		return true
	else return false end
end
function c22024530.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22024530.coincon2)
	e1:SetOperation(c22024530.coinop2)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c22024530.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c22024530.coinop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22024530)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=0,ct do
		res[i]=0
	end
	Duel.SetCoinResult(table.unpack(res))
end
function c22024530.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22024530.cfilter(c)
	return c:IsFaceup() and c.toss_coin
end
function c22024530.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22024530.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22024530.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroupCount(c22024530.cfilter,tp,0,LOCATION_MZONE,nil)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22024530.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22024530.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(c22024530.cfilter,tp,0,LOCATION_MZONE,nil)
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000*ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end