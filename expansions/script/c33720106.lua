--[[
亡命骗徒 『先驱者』
Desperado Trickster - "The Forerunner"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	aux.AddLinkProcedure(c,s.material,1,1)
	c:EnableReviveLimit()
	--If you declare a statement with a "Desperado Trickster" monster effect, your opponent must challenge it.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(CARD_DESPERADO_TRICKSTER_THE_FORERUNNER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	--Each time your opponent challenges a "Desperado Trickster" card effect: Gain 1200 LP.
	local MZChk=aux.AddThisCardInMZoneAlreadyCheck(c)
	local e2=Effect.CreateEffect(c)
	e2:Desc(0)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DESPERADO_CHALLENGED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(MZChk)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	aux.RegisterTriggeringArchetypeCheck(c,ARCHE_DESPERADO_TRICKSTER)
end
function s.material(c)
	return not c:IsLinkType(TYPE_LINK) and c:IsLinkAttribute(ATTRIBUTE_DARK) and c:IsLinkSetCard(ARCHE_DESPERADO_TRICKSTER)
end

--E2
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckArchetypeReasonEffect(s,re,ARCHE_DESPERADO_TRICKSTER) and eg:IsExists(aux.AlreadyInRangeFilter(e),1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,1200)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end