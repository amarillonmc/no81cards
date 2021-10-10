--汐斯塔·据点-汐斯塔市
function c79029126.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029126.target)
	e1:SetOperation(c79029126.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029126.eqlimit)
	c:RegisterEffect(e2)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c79029126.discon)
	e2:SetTarget(c79029126.distg)
	e2:SetOperation(c79029126.disop)
	c:RegisterEffect(e2)
	--atk 
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetValue(c79029126.val)
	c:RegisterEffect(e6)   
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)   
end
function c79029126.val(e,c,Counter) 
	return e:GetHandler():GetEquipTarget():GetBaseAttack()/2
end
function c79029126.eqlimit(e,c)
	return c:IsSetCard(0xa900)
end
function c79029126.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029126.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029126.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029126.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029126.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029126.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c79029126.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS) and re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)
end
function c79029126.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,eg,1,0,0)
end
function c79029126.disop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1099,1)
end







