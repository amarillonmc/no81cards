--侵入乌托兰梦境的梦魇魔
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.Link(c)
	local e1 = Scl.CreatePlayerBuffEffect(c, id, 1, nil, { 1, 0 }, "MonsterZone")
end