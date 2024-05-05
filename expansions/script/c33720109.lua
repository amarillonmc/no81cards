--[[
亡命骗徒 『生命苦短』
Desperado Trickster - "Vita Brevis"
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
end

function s.e1(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REPLACE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	return e1,true
end
function s.damval(e,re,val,r,rp,rc)
	if val<2000 then
		Duel.IgnoreActionCheck(Duel.Recover,e:GetHandlerPlayer(),val*2,REASON_EFFECT|REASON_RRECOVER)
		return 0
	end
	return val
end