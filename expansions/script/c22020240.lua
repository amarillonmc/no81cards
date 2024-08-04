--人理之诗 干将莫邪
function c22020240.initial_effect(c)
	aux.AddCodeList(c,22020220,22020230)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c22020240.target)
	e1:SetOperation(c22020240.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c22020240.eqlimit)
	c:RegisterEffect(e4)
	--grave to equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22020240,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,22020240)
	e5:SetTarget(c22020240.eqtg)
	e5:SetOperation(c22020240.eqop)
	c:RegisterEffect(e5)
	--boost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsCode,22020220))
	e6:SetValue(500)
	e6:SetCondition(c22020240.condition)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
end
function c22020240.eqlimit(e,c)
	return c:IsFaceup() and (c:IsCode(22020220) or c.effect_canequip_hogu)
end
function c22020240.filter(c)
	return c:IsFaceup() and (c:IsCode(22020220) or c.effect_canequip_hogu)
end
function c22020240.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22020240.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020240.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22020240.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22020240.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c22020240.filter(c)
	return c:IsFaceup() and (c:IsCode(22020220) or c.effect_canequip_hogu)
end
function c22020240.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c22020240.filter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c22020240.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22020240.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c22020240.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc)
	end
end
function c22020240.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020230)
end
function c22020240.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020240.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end