--[[
亡命骗徒 『光阴似箭』
Desperado Trickster - "Tempus Fugit"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	aux.RegisterDesperadoGeasGenerationEffect(c,id,EFFECT_FLAG_DELAY,nil,nil,s.e1)
	if not s.global_check then
		s.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetOperation(s.regop)
		Duel.RegisterEffect(e1,0)
	end
end
function s.regfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(c:GetControler()) and not c:IsReason(REASON_DRAW)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(s.regfilter,1,nil,p) then
			Duel.RegisterFlagEffect(p,id+100,RESET_PHASE|PHASE_END,0,1)
		end
	end
end

function s.e1(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:OPT()
	e1:SetCondition(s.drawcon)
	e1:SetOperation(s.drawop)
	return e1,true
end
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return 1-p==tp and Duel.PlayerHasFlagEffect(p,id+100)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Draw(tp,2,REASON_EFFECT)
end