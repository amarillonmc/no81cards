--冥魂城
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103016
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.actcon)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.atkcon)
	e3:SetTarget(cm.atktg)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x337) and c:IsControler(tp)
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and cm.cfilter(a,tp)) or (d and cm.cfilter(d,tp))
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
end
function cm.atktg(e,c)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and cm.cfilter(a,tp) and a==c) or (d and cm.cfilter(d,tp) and d==c)
end
function cm.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if c:GetFlagEffect(m)~=0 then return 800 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
	return 800
end