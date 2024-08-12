if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=aux.AddLinkProcedure(c,s.matfilter,1,1)
	e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	c:EnableReviveLimit()
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	eg:ForEach(Card.RegisterFlagEffect,id,RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
end
function s.matfilter(c)
	return c:GetFlagEffect(id)==0
end
