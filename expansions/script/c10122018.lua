--乌托兰的盗梦者
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.Link(c)
	local e1 = Scl_Utoland.Unaffected(c)
	local e2 = Scl.CreateFieldTriggerOptionalEffect(c, "BePlacedOnField", "ActivateSpell", {1, id}, "ActivateSpell", "Delay", "MonsterZone", s.con, nil, {"~Target", "ActivateSpell", s.afilter, "Hand,Deck,GY" }, s.aop)
end
function s.cfilter(c,tp)
	return c:IsCode(10122011) and c:IsFaceup() and c:IsControler(tp)
end
function s.con(e,tp,eg)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.afilter(c,e,tp)
	local fc = Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return c:IsSetCard(0xc333) and Scl.IsType(c,0,TYPE_SPELL+TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and (not fc or fc:IsFacedown() or not fc:IsCode(c:GetCode()))
end
function s.aop(e,tp)
	Scl.SelectAndOperateCards("ActivateSpell",tp,aux.NecroValleyFilter(s.afilter),tp,"Hand,Deck,GY",0,1,1,nil,e,tp)()
end