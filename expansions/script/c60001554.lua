--次元超越
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
cm.isSpellboost=true
function cm.initial_effect(c)
	byd.Spellboost(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffect(60001538)
	if chk==0 then return ct>=20 and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(60001538)
	if ct<20 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end