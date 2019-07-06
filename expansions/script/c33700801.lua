--VOICEROID 缘  ～凛～
if not pcall(function() require("expansions/script/c33700784") end) then require("script/c33700784") end
local m=33700801
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsvo.YukaLinkFunction(c)  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)  
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.aclimit)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3) 
end
function cm.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function cm.atkval(e,c)
	return c:GetLinkedGroup():FilterCount(cm.cfilter,nil)*800
end
function cm.cfilter(c)
	return c:IsSetCard(0x144c) and c:IsFaceup()
end