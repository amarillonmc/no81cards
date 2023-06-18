--恶念体增幅兵器
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormalSummoned",
		"PlaceInSpell&TrapZone", nil, nil, "Delay", nil, nil,
		{ "~Target", "PlaceInSpell&TrapZone", s.pfilter, "Deck,GY" }, s.tfop)
	local e2 = Scl.CreateQuickOptionalEffect(c, nil, "BanishFacedown", 1, 
		"BanishFacedown", "Target", "MonsterZone", nil, nil, {
		{ "Target", "BanishFacedown", s.bfilter, 0, "GY"}, { "~Target", "Return2Hand", s.rtfilter, "OnField", 0, 1, 1, c }} , s.bop)
end
function s.pfilter(c,e,tp)
	return aux.IsCodeListed(c, 10106003) and Scl.IsType(c,TYPE_CONTINUOUS,TYPE_TRAP,TYPE_SPELL) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function s.tfop(e,tp)
	Scl.SelectAndOperateCards("PlaceInSpell&TrapZone",tp,aux.NecroValleyFilter(s.pfilter),tp,"Deck,GY",0,1,1,nil,e,tp)()
end
function s.bfilter(c,e,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.rtfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0x3338)
end
function s.bop(e,tp)
	if Scl.SelectAndOperateCards("Return2Hand",tp,s.rtfilter,tp,"OnField",0,1,1,aux.ExceptThisCard(e))() > 0 and Scl.IsCorrectlyOperated("Hand") then
		local _, tc = Scl.GetTargetsReleate2Chain()
		if not tc then return end
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end