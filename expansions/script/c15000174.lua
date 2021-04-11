local m=15000174
local cm=_G["c"..m]
cm.name="精灵弓·绶光"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(cm.eqlimit)
	c:RegisterEffect(e2)
	--Actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(15000174)
	e4:SetOperation(cm.bowop)
	c:RegisterEffect(e4)
	cm.spirit_bow_effect=e4
end
function cm.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_BEASTWARRIOR)
end
function cm.filter(c)
	return c:IsFaceup() and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_BEASTWARRIOR))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function cm.actcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function cm.bowop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_SZONE,0,1,nil)
	local op=0
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		op=Duel.SelectOption(tp,aux.Stringid(15000174,0),aux.Stringid(15000174,1))
	end
	if not b1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		op=Duel.SelectOption(tp,aux.Stringid(15000174,1))+1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dc=Duel.SelectMatchingCard(tp,nil,1-tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		if dc then Duel.Destroy(dc,REASON_EFFECT) end
	end
	if op==1 then
		Duel.Damage(1-tp,c:GetAttack(),REASON_EFFECT)
	end
end