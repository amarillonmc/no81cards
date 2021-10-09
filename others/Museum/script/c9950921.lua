--宝具-直死魔眼
function c9950921.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c9950921.target)
	e1:SetOperation(c9950921.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c9950921.eqlimit)
	c:RegisterEffect(e2)
	--Atk Def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c9950921.val)
	c:RegisterEffect(e2)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c9950921.ftarget)
	c:RegisterEffect(e4)
	--chain limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c9950921.chcon)
	e4:SetOperation(c9950921.chop)
	c:RegisterEffect(e4)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950921,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c9950921.rmcon)
	e3:SetTarget(c9950921.rmtg)
	e3:SetOperation(c9950921.rmop)
	c:RegisterEffect(e3)
end
function c9950921.eqlimit(e,c)
	return c:IsSetCard(0xba5) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9950921.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9950921.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9950921.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950921.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9950921.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9950921.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9950921.ftarget(e,c)
	return e:GetHandler():GetEquipTarget()~=c
end
function c9950921.val(e,c)
	local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
	return math.max(0,ct-1)
end
function c9950921.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler():GetEquipTarget()
end
function c9950921.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c9950921.chlimit)
end
function c9950921.chlimit(e,ep,tp)
	return ep==tp
end
function c9950921.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c9950921.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9950921.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(1-tp) and c9950921.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950921.filter2,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9950921.filter2,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE+LOCATION_MZONE)
end
function c9950921.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
