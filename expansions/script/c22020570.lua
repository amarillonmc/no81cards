--人理之诗 多元重奏饱和炮击
function c22020570.initial_effect(c)
	aux.AddCodeList(c,22020540)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22020570.cost0)
	e1:SetTarget(c22020570.target)
	e1:SetOperation(c22020570.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c22020570.eqlimit)
	c:RegisterEffect(e2)
	--atk&def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,22020570)
	e6:SetCost(c22020570.cost)
	e6:SetTarget(c22020570.destg)
	e6:SetOperation(c22020570.desop)
	c:RegisterEffect(e6)
end
function c22020570.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("肌肉系统、神经系统、血管系统、淋巴系统——")
end
function c22020570.eqlimit(e,c)
	return c:IsFaceup() and (c:IsCode(22020220) or c.effect_canequip_hogu)
end
function c22020570.filter(c)
	return c:IsFaceup() and (c:IsCode(22020220) or c.effect_canequip_hogu)
end
function c22020570.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22020570.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020570.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22020570.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22020570.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Debug.Message("疑似魔术回路变换、完成！")
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c22020570.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	Debug.Message("这就是我的全部！")
end
function c22020570.filter1(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c22020570.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetEquipTarget():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c22020570.filter1,tp,0,LOCATION_MZONE,1,c,atk) end
	local g=Duel.GetMatchingGroup(c22020570.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c22020570.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local atk=c:GetEquipTarget():GetAttack()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c22020570.filter1,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e),atk)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Debug.Message("多元重奏——饱和炮击！")
	if ct>0 and ec and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end