--幻梦界 妖梦
function c22050270.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22050270,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22050270)
	e1:SetCost(c22050270.cost)
	e1:SetTarget(c22050270.atktg)
	e1:SetOperation(c22050270.atkop)
	c:RegisterEffect(e1)
	c22050270.discard_effect=e1
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22050270,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,22050270)
	e2:SetCondition(c22050270.con)
	e2:SetCost(c22050270.cost1)
	e2:SetTarget(c22050270.atktg)
	e2:SetOperation(c22050270.atkop)
	c:RegisterEffect(e2)
	--double
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22050270,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22050271)
	e3:SetCondition(c22050270.condition)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22050270.target)
	e3:SetOperation(c22050270.operation)
	c:RegisterEffect(e3)
end
function c22050270.con(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.GetTurnPlayer()~=tp
end
function c22050270.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22050270.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c22050270.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c22050270.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22050270.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22050270.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22050270.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22050270.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c22050270.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c22050270.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c22050270.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
