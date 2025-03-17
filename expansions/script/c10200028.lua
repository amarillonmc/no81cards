--火炎宝珠
function c10200028.initial_effect(c)
	-- activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c10200028.target)
	e1:SetOperation(c10200028.activate)
	c:RegisterEffect(e1)
	-- 限制条件
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10200028.eqlimit)
	c:RegisterEffect(e2)
    -- 攻击力上升
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(c10200028.con1)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
-- 1
function c10200028.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c10200028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10200028.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10200028.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c10200028.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c10200028.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c10200028.eqlimit(e,c)
	return c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_FIRE)
end
-- 2
function c10200028.con1(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsAttribute(ATTRIBUTE_FIRE)
end