--乌托兰的织梦人
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl.AddTokenList(c, 10122011)
	Scl_Utoland.Link(c)
	local e1 = Scl_Utoland.Unaffected(c)
	local e2 = Scl.CreateQuickOptionalEffect(c, "FreeChain", "SpecialSummonToken", {1,id}, "SpecialSummonToken", nil, "MonsterZone", nil, nil, Scl_Utoland.Token_Target(1, 1, nil, true), s.spop)
end
function s.spop(e,tp)
	Scl_Utoland.SpecialSummonToken(e:GetHandler(), tp, 1, 1, s.buff)
end
function s.buff(c,tk)
	local e1 = Scl.CreateSingleBuffEffect({c,tk}, "!BeUsedAsMaterial4LinkSummon", 1, "OnField", nil, RESETS_EP_SCL, {id,0}, nil, "ClientHint")
end