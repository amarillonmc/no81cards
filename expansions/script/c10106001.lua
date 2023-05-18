--恶念体制造兵器
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormalSummoned",
		"Search", nil, "Search,Add2Hand", "Delay", nil, nil, 
		{ "~Target", "Add2Hand", s.thfilter, "Deck" }, s.thop)
	local e2 = Scl.CreateQuickOptionalEffect(c, nil, "ChangeControl", 1, 
		"ChangeControl", "Target", "MonsterZone", nil, nil, {
		{ "Target", "ChangeControl", s.ctfilter, 0, "MonsterZone"}, { "~Target", "Return2Hand", s.rtfilter, "OnField", 0, 1, 1, c }} , s.ctop)
end
function s.thfilter(c)
	return c:IsSetCard(0x3338) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thop(e,tp)
	Scl.SelectAndOperateCards("Add2Hand",tp,s.thfilter,tp,"Deck",0,1,1,nil)()
end
function s.ctfilter(c)
	return c:IsControlerCanBeChanged() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.rtfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0x3338)
end
function s.ctop(e,tp)
	if Scl.SelectAndOperateCards("Return2Hand",tp,s.rtfilter,tp,"OnField",0,1,1,aux.ExceptThisCard(e))() > 0 and Scl.IsCorrectlyOperated("Hand") then
		local _, tc = Scl.GetTargetsReleate2Chain()
		if not tc then return end
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end