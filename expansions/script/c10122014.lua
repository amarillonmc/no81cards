--乌托兰深层 迷失雨林
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.DeepFieldEffects(c, id, "BeAdded2Hand", s.con)
end
function s.cfilter(c,tp)
	return c:IsControler(1-tp)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and Duel.GetCurrentPhase() ~= PHASE_DRAW 
end

