--H.P.T.-006
local m=12899013
local cm=_G["c"..m]
function cm.initial_effect(c)
 c:SetUniqueOnField(1,0,m)
--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(cm.sdcon)
	c:RegisterEffect(e1)
 --remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.con1)
	e2:SetTarget(cm.rmtarget)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetTarget(cm.checktg)
	c:RegisterEffect(e3)
--
 local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.con2)
	e4:SetTargetRange(0xff,0xff)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
  --Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e5)
end
function cm.filter(c)
	return ((not c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.filter2(c)
	return ((c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.actcon(e)
	return  (not Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)  and Duel.IsExistingMatchingCard(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil))
end

function cm.sdfilter(c)
	return not c:IsFaceup() or not c:IsSetCard(0x5a71)
end
function cm.sdcon(e)
	return  Duel.IsExistingMatchingCard(cm.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function cm.con1(e)
	return   Duel.IsExistingMatchingCard(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.con2(e)
	return  not Duel.IsExistingMatchingCard(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.rmtarget(e,c)
	return  not c:IsSetCard(0x6a71)
end
function cm.checktg(e,c)
	return not c:IsPublic()
end