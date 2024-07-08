--人理之诗 誓约胜利之剑
function c22020050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22020050.target)
	e1:SetOperation(c22020050.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c22020050.eqlimit)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c22020050.atkval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22020050,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,22020050)
	e4:SetTarget(c22020050.destg)
	e4:SetOperation(c22020050.desop)
	c:RegisterEffect(e4)
end
c22020050.effect_with_altria=true
function c22020050.eqlimit(e,c)
	return c:IsFaceup() and (c:IsSetCard(0xff9) or c.effect_canequip_hogu)
end
function c22020050.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0xff9) or c.effect_canequip_hogu)
end
function c22020050.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22020050.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020050.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22020050.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22020050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		Duel.SelectOption(tp,aux.Stringid(22020050,1))
	end
end
function c22020050.atkval(e,c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()*300
	else
		return c:GetLevel()*300
	end
end
function c22020050.filter1(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c22020050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetEquipTarget():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c22020050.filter1,tp,0,LOCATION_MZONE,1,c,atk) end
	local g=Duel.GetMatchingGroup(c22020050.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22020050.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetEquipTarget():GetAttack()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c22020050.filter1,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e),atk)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.SelectOption(tp,aux.Stringid(22020050,2))
	if ct>0 then
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end