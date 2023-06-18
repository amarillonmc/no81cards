--前往乌托兰深层的领路人
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.Link(c)
	local e1 = Scl_Utoland.Unaffected(c)
	local e2 = Scl.CreateQuickOptionalEffect(c, "FreeChain", {id, 0}, {1, id}, nil, "Target", "MonsterZone", nil, nil, {"Target", "Opponent", s.cfilter, 0, "OnField"}, s.op)
end
function s.cfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(id) == 0
end
function s.op(e,tp)
	local _,tc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	local c = e:GetHandler()
	if not tc or tc:GetFlagEffect(id) ~= 0 then return end
	tc:RegisterFlagEffect(id,RESETS_SCL,EFFECT_FLAG_CLIENT_HINT,1,tp,aux.Stringid(id,1))
	local e1 = Scl.CreateSingleBuffEffect({c,tc,true}, "ExtraLinkMaterial", s.matval, "OnField", nil, RESETS_SCL)
	e1:SetLabel(tp)
end
function s.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0xc333) or tp ~= e:GetLabel() then return false, nil end
	return true,true
end