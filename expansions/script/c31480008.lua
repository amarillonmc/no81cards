local m=31480008
local cm=_G["c"..m]
cm.name="神欲大磐舟"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetOperation(cm.equdisop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_MOVE)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(cm.eqlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(1000)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(cm.efilter)
	c:RegisterEffect(e7)
end
function cm.eqlimit(e,c)
	return c:IsSetCard(0x1313)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1313)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) and not c:IsLocation(LOCATION_DECK) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		local lp=Duel.GetLP(c:GetControler())
		Duel.Recover(c:GetControler(),1000,REASON_EFFECT)
	end
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_ONFIELD)
end
function cm.equdisop(e,tp)
	local c=e:GetHandler():GetEquipTarget()
	return c:GetColumnZone(LOCATION_ONFIELD)
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end