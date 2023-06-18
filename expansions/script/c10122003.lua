--乌托兰秘境 星辉原野
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.FieldEffects(c, id, { "PlayerCost", "Discard", 1 }, nil, 1, 2)
end