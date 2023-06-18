--乌托兰秘境 平和海滩
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.FieldEffects(c, id, nil, nil, 1, 1, s.exop)
end
function s.exop(e,tp)
	local e1 = Scl.CreatePlayerBuffEffect({e:GetHandler(),tp},"!SpecialSummon", 1, s.tg, {1,0}, nil, nil, RESETS_EP_SCL)
end
function s.tg(e,c)
	return not c:IsSetCard(0xc333)
end