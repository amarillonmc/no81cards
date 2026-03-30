--私密决斗
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)   
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.xxop) 
	c:RegisterEffect(e1)
end
function s.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.ConfirmCards(1-tp,c)
	local ac=Duel.CreateToken(tp,359563)
	ac:SetMaterial(Group.FromCards(c))
	Duel.Overlay(ac,c)
end