--乌托兰深层 死域之海
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.DeepFieldEffects(c, id, "DeclareAttack", s.con, 1, 2)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

