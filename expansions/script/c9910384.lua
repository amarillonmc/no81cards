--丛雨丸
function c9910384.initial_effect(c)
	aux.AddCodeList(c,9910376)
	c:SetUniqueOnField(1,0,9910384)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9910384.target)
	e1:SetOperation(c9910384.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c9910384.eqlimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetCondition(c9910384.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c9910384.atkcon)
	e6:SetOperation(c9910384.atkop)
	c:RegisterEffect(e6)
end
function c9910384.eqlimit(e,c)
	return aux.IsCodeListed(c,9910376)
end
function c9910384.filter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9910376)
end
function c9910384.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c9910384.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910384.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9910384.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9910384.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9910384.indcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c9910384.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	return ec and tc and tc:IsFaceup() and tc:IsControler(1-tp)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c9910384.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if ec and tc and ec:IsFaceup() and tc:IsFaceup() then
		local sum=tc:GetAttack()+tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(math.ceil(sum/2))
		ec:RegisterEffect(e1)
	end
end
