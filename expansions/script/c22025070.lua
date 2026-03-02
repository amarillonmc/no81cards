--人理之诗 疾风怒涛的不死战车
function c22025070.initial_effect(c)
	aux.AddCodeList(c,22025040)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22025070.target)
	e1:SetOperation(c22025070.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c22025070.eqlimit)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c22025070.atkcon)
	e3:SetTarget(c22025070.ftarget)
	c:RegisterEffect(e3)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(c22025070.val)
	c:RegisterEffect(e4)
	--aeg
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c22025070.aegcon)
	e5:SetOperation(c22025070.aegop)
	c:RegisterEffect(e5)
end
function c22025070.eqlimit(e,c)
	return c:IsFaceup() and (c:IsCode(22025040) or c.effect_canequip_hogu)
end
function c22025070.filter(c)
	return c:IsFaceup() and (c:IsCode(22025040) or c.effect_canequip_hogu)
end
function c22025070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22025070.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22025070.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22025070.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22025070.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c22025070.ftarget(e,c)
	return e:GetHandler():GetEquipTarget()~=c
end
function c22025070.val(e,c)
	local ct=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)
	return math.max(0,ct-1)
end
function c22025070.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,22025070)==0 
end
function c22025070.aegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and re:GetHandler():IsCode(22025820) and Duel.GetFlagEffect(tp,22025070)==0
end
function c22025070.aegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(22025070,0)) then
		Duel.Hint(HINT_CARD,0,22025070)
		Duel.RegisterFlagEffect(tp,22025070,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22025070,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
end