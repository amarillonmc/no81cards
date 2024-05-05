--[[
亡命骗徒 『先驱者』
Desperado Trickster - "Tu Fui, Ego Eris"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,ARCHE_DESPERADO_TRICKSTER),1,nil,s.lcheck)
	c:EnableReviveLimit()
	aux.RegisterDesperadoGeasGenerationEffect(c,id,EFFECT_FLAG_DELAY,nil,nil,s.e1,s.e2)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end

function s.e1(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.drawcon)
	e1:SetOperation(s.drawop)
	return e1
end
function s.cfilter(c,tp)
	return not c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsSummonPlayer(tp)
end
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Draw(1-tp,2,REASON_EFFECT)
end

function s.e2(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,5))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.atktg)
	e2:SetValue(1800)
	return e2
end
function s.atktg(e,c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end