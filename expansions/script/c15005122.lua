local m=15005122
local cm=_G["c"..m]
cm.name="断空鹰刃-天桴一θ"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(15005122)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--Equip Link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(cm.matval)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(cm.mattg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--attack twice
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6f3f)
end
function cm.mattg(e,c)
	return c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function cm.mfilter(c,sc)
	return c:IsLocation(LOCATION_MZONE) and c:IsLinkSetCard(0x6f3f) and c==sc:GetEquipTarget()
end
function cm.exmfilter(c,sc)
	return c:IsLocation(LOCATION_SZONE) and c==sc
end
function cm.matval(e,lc,mg,c,tp)
	if not lc:IsHasEffect(15005122) then return false,nil end
	return true,not mg or mg:IsExists(cm.mfilter,1,nil,c) and not mg:IsExists(cm.exmfilter,1,nil,c)
end
function cm.eqcfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function cm.atkval(e,c)
	local eqg=c:GetEquipGroup():Filter(cm.eqcfilter,nil)
	return eqg:GetSum(Card.GetBaseAttack)
end