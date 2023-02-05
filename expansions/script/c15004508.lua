local m=15004508
local cm=_G["c"..m]
cm.name="古亚四灾·简"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	c:RegisterEffect(e0)
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(cm.oppocon)
	e2:SetTarget(cm.ootarget)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cant banish by eff
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(cm.oppocon)
	e3:SetTarget(cm.rmlimit)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetCondition(cm.selfcon)
	e4:SetTarget(cm.ootarget)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function cm.spfilter1(c,p)
	return not c:IsAbleToRemove(p)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	return Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cm.ootarget(e,c)
	return true
end
function cm.selfcon(e)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==c:GetControler()
end
function cm.rmlimit(e,c,tp,r)
	return r==REASON_EFFECT
end
function cm.oppocon(e)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==1-c:GetControler()
end