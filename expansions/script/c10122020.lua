--乌托兰的造访者
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	local e1, e2 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormal/SpecialSummoned", "Add2Hand", {1, id}, "Add2Hand", "Delay", nil, nil, { "~Target", "Add2Hand", s.thfilter, "GY,Deck" }, s.thop)
	local e3 = Scl.CreateIgnitionEffect(c, "Add2Hand", {1, id}, "Add2Hand", nil, "GY", s.con, aux.bfgcost, { "~Target", "Add2Hand", s.thfilter2, "GY,Deck" }, s.thop2)
end
function s.thfilter(c)
	return c:IsCode(10122009) and c:IsAbleToHand()
end
function s.thop(e,tp)
	Scl.SelectAndOperateCards("Add2Hand",tp,aux.NecroValleyFilter(s.thfilter),tp,"GY,Deck", 0, 1, 1, nil)()
end
function s.con(e,tp)
	local fc = Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return fc and fc:IsFaceup() and fc:IsSetCard(0xc333)
end
function s.thfilter2(c)
	return c:IsCode(10122010) and c:IsAbleToHand()
end
function s.thop2(e,tp)
	Scl.SelectAndOperateCards("Add2Hand",tp,aux.NecroValleyFilter(s.thfilter2),tp,"GY,Deck", 0, 1, 1, nil)()
end