--恶念体复制兵器
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormalSummoned",
		"AddFromDeck/GY2Hand", nil, "AddFromDeck/GY2Hand", "Delay", 
		nil, nil, {
		{ "~Target", "Look", s.codefilter, "Hand,OnField"  },
		{ "~Target", "Add2Hand", aux.TRUE, "Deck,GY"} }, s.thop)
	local e2 = Scl.CreateQuickOptionalEffect(c, nil, "Destroy", 1, 
		"Destroy", "Target", "MonsterZone", nil, nil, {
		{ "Target", "Destroy", aux.TRUE, 0, "OnField"}, { "~Target", "Return2Hand", s.rtfilter, "OnField", 0, 1, 1, c }} , s.desop)
end
function s.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function s.codefilter(c,e,tp)
	return c:IsSetCard(0x3338) and Scl.IsOriginalType(c, 0, TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode()) and not c:IsCode(id)
end
function s.thop(e,tp)
	local _,_,tc = Scl.SelectAndOperateCards("Look",tp,s.codefilter,tp,"Hand,OnField",0,1,1,nil,e,tp)()
	if not tc then return end
	Scl.SelectAndOperateCards("Add2Hand",tp,aux.NecroValleyFilter(s.thfilter),tp,"Deck,GY",0,1,2,nil,tc:GetCode())()
end
function s.rtfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0x3338)
end
function s.desop(e,tp)
	if Scl.SelectAndOperateCards("Return2Hand",tp,s.rtfilter,tp,"OnField",0,1,1,aux.ExceptThisCard(e))() > 0 and Scl.IsCorrectlyOperated("Hand") then
		local _, tc = Scl.GetTargetsReleate2Chain()
		if not tc then return end
		Duel.Destroy(tc,REASON_EFFECT)
	end
end