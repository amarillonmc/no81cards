--异位魔的威压
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10106003)
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateQuickOptionalEffect(c, nil, "Look", 1,
		"SpecialSummonFromHand/GY", nil, "Spell&TrapZone", nil, nil, 
		{ "~Target", "Dummy", aux.TRUE, 0, "Hand,GY" }, s.spop)
	local e3 = Scl.CreateFieldTriggerOptionalEffect(c, "BeAdded2Hand", 
		"Add2Hand", 1, "Search,Add2Hand" , "Delay", "Spell&TrapZone", 
		nil, nil, s.thtg, s.thop)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE ) > 0
end
function s.spop(e,tp)
	local g = Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_GRAVE)
	if #g == 0 then return end
	Duel.ConfirmCards(tp, g) 
	if g:IsExists(s.spfilter,1,nil,e,tp) and Scl.SelectYesNo(tp, "SpecialSummon") then
		local sg = g:FilterSelect(tp, s.spfilter, 1, 1, nil, e, tp)
		Scl.HintSelection(sg)
		Scl.AddSingleBuff(nil, "NegateEffect,NegateActivatedEffect", 1)
		Scl.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
function s.pfilter(c,tp)
	return not c:IsPublic() and c:IsControler(tp) and c:IsSetCard(0x3338) and c:IsPreviousSetCard(0x3338) and c:IsType(TYPE_MONSTER) and Scl.IsOriginalType(c, 0, "Monster") and (not c:IsReason(REASON_DRAW) or not c:IsReason(REASON_RULE)) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.thfilter(c,code)
	return c:IsCode(0x3338) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then
		return e:IsCostChecked() and eg:IsExists(s.pfilter,1,nil,tp)
	end
	local ct,og,tc = Scl.SelectAndOperateCardsFromGroup("Reveal",eg,tp,s.pfilter,1,1,nil,tp)()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp)
	local tc = Duel.GetFirstTarget()
	Scl.SelectAndOperateCards("Add2Hand",tp,aux.NecroValleyFilter(s.thfilter),tp,"Deck,GY",0,1,1,nil,tc:GetCode())()
end