--乌托兰最深层-迷失域之主
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.Link(c)
	local e1 = Scl_Utoland.Unaffected(c)
	local e2 = Scl.CreateQuickOptionalEffect_NegateActivation(c, "Banish", 1, "MonsterZone", { "All", 1 }, { "Cost", "Tribute", s.tfilter, "OnField" })
end
function s.tfilter(c)
	return c:IsSetCard(0xc333) and Scl.IsOriginalType(c,0,TYPE_MONSTER)
end