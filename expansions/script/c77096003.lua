--永不停歇的玻璃鞋
function c77096003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c77096003.target)
	e1:SetOperation(c77096003.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c77096003.eqlimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)   
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCondition(c77096003.atkcon)
	e2:SetCost(c77096003.atkcost)
	e2:SetOperation(c77096003.atkop)
	c:RegisterEffect(e2) 
end
function c77096003.eqlimit(e,c)
	return c:IsCode(77096002) 
end
function c77096003.filter(c)
	return c:IsFaceup() and c:IsCode(77096002)
end
function c77096003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77096003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77096003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77096003.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77096003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c77096003.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,b=Duel.GetBattleMonster(tp) 
	local ec=c:GetEquipTarget()
	return a and b and ec and a==ec 
end
function c77096003.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(77096003)==0 end
	c:RegisterFlagEffect(77096003,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c77096003.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,b=Duel.GetBattleMonster(tp) 
	local ec=c:GetEquipTarget()
	if a:IsRelateToBattle() and a:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-1234)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		a:RegisterEffect(e1) 
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1234)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		a:RegisterEffect(e1)
	end
end


