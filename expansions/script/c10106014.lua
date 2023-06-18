--恶念聚集
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10106003)
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateIgnitionEffect(c, "Search", 1, 
		"AddFromDeck2Hand,NormalSummon", "Target",
		"Spell&TrapZone", nil, 
		{ "PlayerCost", "Discard", 1},
		{{ "Target", "Dummy", s.cfilter, "OnField" },
		{ "~Target", "Add2Hand", Card.IsAbleToHand, "Deck,GY" }}, s.thop)
	local e3 = Scl.CreateFieldTriggerContinousEffect(c, "ActivateEffect",
		nil, nil, nil, "Spell&TrapZone", nil, s.lcop)
end
function s.cfilter(c,e,tp)
	return Scl.IsOriginalType(c,0,TYPE_MONSTER) and c:IsSetCard(0x3338) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetOriginalLevel())
end
function s.thfilter(c,lv)
	return c:IsAbleToHand() and c:IsSetCard(0x3338) and c:IsType(TYPE_MONSTER) and c:GetOriginalLevel() ~= lv
end
function s.thop(e,tp)
	local _,tc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	if not tc then return end
	if Scl.SelectAndOperateCards("Add2Hand",tp,aux.NecroValleyFilter(s.thfilter),tp,"Deck,GY",0,1,1,nil,tc:GetOriginalLevel())() > 0 and Scl.IsCorrectlyOperated("Hand") then
		Scl.SetExtraSelectAndOperateParama("NormalSummon", true)
		Scl.SelectAndOperateCards("NormalSummon",tp,s.sumfilter,tp,"Hand,MonsterZone",0,1,1,nil)()
	end
end
function s.sumfilter(c)
	return c:IsSetCard(0x3338) and c:IsSummonable(true,nil)
end
function s.lcop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x3338) and ep==tp then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end