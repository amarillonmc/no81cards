--莱茵生命·据点-哥伦比亚小屋
function c79029080.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029080.target)
	e1:SetOperation(c79029080.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029080.eqlimit)
	c:RegisterEffect(e2)
	--RECOVER
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79029080.ccon)
	e3:SetTarget(c79029080.ctg)
	e3:SetOperation(c79029080.coper)
	c:RegisterEffect(e3)   
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c79029080.con)
	e4:SetTarget(c79029080.cttg)
	e4:SetOperation(c79029080.ctop)
	c:RegisterEffect(e4)
end
function c79029080.eqlimit(e,c)
	return c:IsSetCard(0xf02)
end
function c79029080.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029080.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029080.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029080.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029080.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c79029080.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsType(TYPE_SPELL+TYPE_EQUIP)
end
function c79029080.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,g,1,0,0)
end
function c79029080.coper(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetEquipTarget():GetAttack()
	Duel.Recover(tp,x/2,REASON_EFFECT)
end
function c79029080.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c79029080.filter2(c)
	return c:IsFaceup() and c:GetCounter(0x1099)>0
end
function c79029080.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsExistingTarget(c79029080.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local a=Duel.SelectTarget(tp,c79029080.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,a,1,0,0)
end
function c79029080.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local x=tc:GetCounter(0x1099)
	e:GetHandler():AddCounter(0x1099,x)
end 


