--罗德岛·据点-源石研究设施
function c79029018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029018.target)
	e1:SetOperation(c79029018.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029018.eqlimit)
	c:RegisterEffect(e2)
	--COUNTER
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79029018.ccon)
	e3:SetTarget(c79029018.ctg)
	e3:SetOperation(c79029018.coper)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c79029018.con)
	e4:SetTarget(c79029018.cttg)
	e4:SetOperation(c79029018.ctop)
	c:RegisterEffect(e4)
end
function c79029018.eqlimit(e,c)
	return c:IsSetCard(0xa900)
end
function c79029018.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029018.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029018.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029018.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c79029018.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsType(TYPE_SPELL+TYPE_EQUIP)
end
function c79029018.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_EQUIP) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x99)
end
function c79029018.coper(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetEquipTarget()
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1099,1)
		x:AddCounter(0x1099,1)
	end
end
function c79029018.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c79029018.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCanAddCounter(0x1099) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,nil,1,e:GetHandler(),0x1099,1) end
end
function c79029018.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,nil,nil,0x1099,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1099,1)
		tc=g:GetNext()
	end
end 