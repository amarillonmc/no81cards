--人理之诗 银河流星剑
function c22021310.initial_effect(c)
	--equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c22021310.eqlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c22021310.target)
	e1:SetOperation(c22021310.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22021310)
	e2:SetCost(c22021310.atkcost)
	e2:SetCondition(c22021310.atkcon)
	e2:SetTarget(c22021310.atktg)
	e2:SetOperation(c22021310.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCost(c22021310.atkcost1)
	e3:SetCondition(c22021310.atkcon1)
	e3:SetTarget(c22021310.atktg1)
	c:RegisterEffect(e3)
end
c22021310.effect_with_altria=true
function c22021310.eqlimit(e,c)
	return c:IsFaceup() and (c:IsSetCard(0xff9) or c.effect_canequip_hogu)
end
function c22021310.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0xff9) or c.effect_canequip_hogu)
end
function c22021310.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c22021310.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22021310.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22021310.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c22021310.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	return ec and not ec:IsType(TYPE_LINK) and tc and tc:IsFaceup() and tc:IsControler(1-tp)
end
function c22021310.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22021310.atkfilter(c)
	return c:IsSetCard(0xff9) and c:GetBaseAttack()>0 and c:IsAbleToGraveAsCost()
end
function c22021310.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c22021310.atkfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22021310.atkfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end
function c22021310.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ec=e:GetHandler():GetEquipTarget()
	local atk=e:GetLabel()
	if ec:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)
	end
end
function c22021310.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	return ec and ec:IsType(TYPE_LINK) and tc and tc:IsFaceup() and tc:IsControler(1-tp)
end
function c22021310.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22021310.atkfilter1(c)
	return c:IsSetCard(0xff1,0xff9) and c:GetBaseAttack()>0 and c:IsAbleToGraveAsCost()
end
function c22021310.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c22021310.atkfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22021310.atkfilter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SelectOption(tp,aux.Stringid(22021310,0))
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end