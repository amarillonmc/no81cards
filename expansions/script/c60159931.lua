--裁决之光
function c60159931.initial_effect(c)
    c:SetSPSummonOnce(60159931)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c60159931.matfilter,1,1)
    --cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c60159931.e1tg)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_TRIGGER)
    c:RegisterEffect(e2)
    --inactivatable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c60159931.e6tg)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_INACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c60159931.effectfilter)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c60159931.effectfilter)
    c:RegisterEffect(e5)
    --cannot attack
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_PIERCE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(c60159931.e6tg)
    c:RegisterEffect(e6)
end
function c60159931.matfilter(c)
    return c:IsAttackPos()
end
function c60159931.e1tg(e,c)
    return not e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c60159931.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
	local wz=e:GetHandler():GetSequence()
    local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_SEQUENCE)
	if wz==5 then
		return p==tp and te:IsActiveType(TYPE_MONSTER) and bit.band(loc,1)~=0
	elseif wz==6 then
		return p==tp and te:IsActiveType(TYPE_MONSTER) and bit.band(loc,3)~=0
	end
end
function c60159931.e6tg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
