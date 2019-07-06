--VOICEROID 灯
if not pcall(function() require("expansions/script/c33700784") end) then require("script/c33700784") end
local m=33700788
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	rsvo.OneReplaceLinkFunction(c) 
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE+RACE_MACHINE),3,3)
	c:EnableReviveLimit()	 
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e2)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.atkval)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function cm.eftg(e,c)
	local lg=e:GetHandler():GetMutualLinkedGroup()
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x144c) and lg:IsContains(c) and not c:IsCode(e:GetHandler():GetCode())
end
function cm.atkval(e,c)
	return c:GetLinkedGroupCount()*1000
end
function cm.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end