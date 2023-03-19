local m=15000885
local cm=_G["c"..m]
cm.name="万恶群生·丁铎拉姆"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,true)
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--All Flip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(cm.fcon)
	e3:SetTarget(cm.fliptg)
	e3:SetValue(TYPE_FLIP)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(cm.fcon)
	e4:SetTarget(cm.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
end
function cm.ffilter(c)
	return c:IsRace(RACE_REPTILE) or c:IsType(TYPE_FLIP)
end
function cm.value(e,c)
	return Duel.GetMatchingGroupCount(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*500
end
function cm.fcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.fliptg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:GetOriginalCode()~=15000885 and c:IsFaceup()
end