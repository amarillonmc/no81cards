--如梦
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	local e1 = Scl.CreateActivateEffect(c, "FreeChain", "ActivateSpell", nil, "ActivateSpell", nil, nil, nil, { "~Target", "ActivateSpell", s.afilter, "Hand,Deck,GY" }, s.act)
end
function s.afilter(c,e,tp)
	return c:IsSetCard(0xc333) and Scl.IsType(c,0,TYPE_SPELL+TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true)
end
function s.act(e,tp)
	Scl.SelectAndOperateCards("ActivateSpell",tp,aux.NecroValleyFilter(s.afilter),tp,"Hand,Deck,GY",0,1,1,nil,e,tp)()
end