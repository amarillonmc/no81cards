--无谋之战
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
    --Attack Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(0x04,0x04)
    e1:SetTarget(s.attg)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
    --Direct Attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0x04,0x04)
	e2:SetTarget(s.datg)
	c:RegisterEffect(e2)
    --Damage Reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,1)
    e3:SetCondition(function(e)
        return Duel.GetAttackTarget()==nil end)
	e3:SetValue(s.damval)
	c:RegisterEffect(e3)
end
function s.attg(e,c)
	e:SetLabelObject(c)
	return true
end
function s.atlimit(e,c)
    local ac=e:GetLabelObject()
	return not c:GetColumnGroup():IsContains(ac)
end
function s.dafilter(c,tp)
    return c:IsLocation(0x04) and c:IsControler(tp)
end
function s.datg(e,c)
    local pl=c:GetControler()
	return c:GetColumnGroup():FilterCount(s.dafilter,nil,1-pl)==0
end
function s.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
        local dam=val/2
        return math.floor(val-dam)
    else return val end
end