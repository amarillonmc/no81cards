--远古英雄
local s,id,o=GetID()
function s.initial_effect(c)
    --cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
    --small eff immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.immval)
	c:RegisterEffect(e1)
    --small atk immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.sfilter)
	c:RegisterEffect(e2)
    --summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(s.ntcon)
	c:RegisterEffect(e3)
end
function s.immval(e,te)
	local tc=te:GetOwner()
	local c=e:GetHandler()
	return te:GetOwner()~=e:GetOwner()
        and not ((tc:IsSummonType(SUMMON_TYPE_ADVANCE) and tc:GetMaterialCount()>1)
        or ((tc:IsSummonType(SUMMON_TYPE_FUSION) or tc:IsSummonType(SUMMON_TYPE_SYNCHRO) or tc:IsSummonType(SUMMON_TYPE_XYZ) or tc:IsSummonType(SUMMON_TYPE_LINK)
        or tc:IsSummonType(SUMMON_TYPE_RITUAL)) and tc:GetMaterialCount()>2) and te:IsActivated())
end
function s.sfilter(e,c)
	return not ((c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:GetMaterialCount()>1)
        or ((c:IsSummonType(SUMMON_TYPE_FUSION) or c:IsSummonType(SUMMON_TYPE_SYNCHRO) or c:IsSummonType(SUMMON_TYPE_XYZ) or c:IsSummonType(SUMMON_TYPE_LINK)
        or c:IsSummonType(SUMMON_TYPE_RITUAL)) and c:GetMaterialCount()>2))
end
function s.ntcon(e,c,minc)
    if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
    and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD+LOCATION_HAND)>=9
end