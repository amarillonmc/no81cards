--黑袍加身
local m=33703014
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(cm.eqlimit)
	c:RegisterEffect(e2)
	--Equip effect-- 
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_EQUIP)
	e12:SetCode(EFFECT_SET_ATTACK_FINAL)
	e12:SetValue(cm.value)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_EQUIP)
	e13:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e14)
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_CANNOT_RELEASE)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetRange(LOCATION_SZONE)
	e15:SetTargetRange(1,1)
	e15:SetTarget(cm.rellimit)
	c:RegisterEffect(e15)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(cm.fuslimit)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
	--maintain
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e24:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e24:SetRange(LOCATION_SZONE)
	e24:SetCountLimit(1)
	e24:SetCondition(cm.mtcon)
	e24:SetOperation(cm.mtop)
	c:RegisterEffect(e24)
	--g euqip
	local e17=Effect.CreateEffect(c)  
	e17:SetCategory(CATEGORY_EQUIP)  
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_GRAVE)
	e17:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e17:SetCondition(cm.eqcon)
	e17:SetTarget(cm.target)
	e17:SetOperation(cm.operation)
	c:RegisterEffect(e17)   
	--leave
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e41:SetCode(EVENT_LEAVE_FIELD)
	e41:SetOperation(cm.desop)
	c:RegisterEffect(e41)
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	
end
--all
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(Card.IsSummonPlayer,nil,0)
	local g2=eg:Filter(Card.IsSummonPlayer,nil,1)
	if #g1>0 then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	end
	if #g2>0 then
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1)
	end
end
--Activate
function cm.eqlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--Equip effect-- 
function cm.value(e,c)
	return c:GetAttack()*2
end
function cm.rellimit(e,c,tp)
	return c==e:GetHandler():GetEquipTarget()
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
--maintain
function cm.mtcon(e)	 
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec or ec==nil or ec:IsAttack(0) then return end
	Duel.Hint(HINT_CARD,0,m) 
	Duel.Damage(ec:GetControler(),ec:GetAttack(),REASON_EFFECT)
end
--g euqip
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,m)>=3 
end
--leave
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end