--异位魔的威信
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10106003)
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateQuickOptionalEffect(c, nil, "Look", 1,
		"SpecialSummonFromDeck/Extra", nil, "Spell&TrapZone", nil, nil, 
		{ "~Target", "Dummy", aux.TRUE, 0, "Deck,Extra" }, s.spop)
	local e2 = Scl.CreateQuickOptionalEffect(c, nil, "Equip", 1, 
		"Equip", "Target", "Spell&TrapZone", nil, nil, {
		{ "Target", "Dummy", Card.IsFaceup, "MonsterZone", "MonsterZone" },
		{ "~Target", "Equip", s.eqfilter, "Hand,Deck,GY" } }, s.eqop)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount( 1- tp,LOCATION_MZONE ) > 0
end
function s.spop(e,tp)
	local g = Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_EXTRA)
	if #g == 0 then return end
	Duel.ConfirmCards(tp, g) 
	if g:IsExists(s.spfilter,1,nil,e,tp) and Scl.SelectYesNo(tp, "SpecialSummon") then
		local sg = g:FilterSelect(tp, s.spfilter, 1, 1, nil, e, tp)
		Scl.HintSelection(sg)
		Scl.AddSingleBuff(nil, "NegateEffect,NegateActivatedEffect", 1)
		Scl.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
function s.eqfilter(c,e,tp)
	return (c:GetOriginalLevel() == 1 or c:GetOriginalLevel() == 4) and c:IsSetCard(0x3338) and Scl.GetSZoneCount(tp) > 0 and not c:IsForbidden()
end
function s.eqop(e,tp)
	local _,tc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	if not tc then return end
	Scl.SelectAndOperateCards("Equip",tp,aux.NecroValleyFilter(s.eqfilter),tp,"Hand,Deck,GY",0,1,1,nil,e,tp)(tc)
end