--侵略の祭坛
function c49811143.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(c49811143.val)
	c:RegisterEffect(e2)
	--release replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c49811143.con)
	e5:SetTarget(c49811143.rrtg)
	e5:SetOperation(c49811143.rrop)
	c:RegisterEffect(e5)
	--destroy replace
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_DESTROY_REPLACE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTarget(c49811143.desreptg)
	e11:SetOperation(c49811143.desrepop)
	c:RegisterEffect(e11)
end
function c49811143.val(e,c)
	return c:GetDefense()*-1
end
function c49811143.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c49811143.tgfilter(c,e,tp)
	return c:IsReleasableByEffect() and c:IsFaceup()
end
function c49811143.rrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c59228631.releasefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49811143.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c49811143.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c49811143.rrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	--as 0x100a	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811143,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(0x100a)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	--releasable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811143,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_RELEASE_SUM)
	e2:SetReset(RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2,tp)
end
function c49811143.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE)
		and Duel.CheckLPCost(tp,1000) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96) 
end
function c49811143.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,1000)
end