--梦游亡灵 百江渚
Duel.LoadScript("c60152900.lua")
local s,id,o = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateQuickOptionalEffect_NegateEffect(c, "Dummy", {1, id}, 
		"Hand,MonsterZone", s.negcon, { "Cost", Card.IsReleasable, "Tribute" },
		"Search,Add2Hand,SpecialSummonFromDeck&GY", nil, nil, s.exop)
	local e2 = Scl.CreateIgnitionEffect(c, "ShuffleIn2Deck", {1, id + 100},
		"ShuffleIn2Deck,Draw", nil,
		"GY", nil, { "Cost", Card.IsAbleToDeckAsCost, "Look&ShuffleIn2Deck" }, {
		{"~Target", s.tdfilter, "ShuffleIn2Deck", "GY,Banished", 0, 
		true, true, c}, {"PlayerTarget", "Draw", 1} }, s.tdop)
end
function s.cfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local arr = { CATEGORY_DESTROY, CATEGORY_REMOVE }
	for _, val in pairs(arr) do
		local ex,tg,tc=Duel.GetOperationInfo(ev,val)
		if ex and tg ~= nil and tc + tg:FilterCount(s.cfilter,nil,tp) - #tg > 0 then
			return true
		end
	end
	return false
end
function s.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function s.exfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.thfilter(c)
	return c:IsSetCard(0x6b29) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return Scl.IsCanBeSpecialSummoned2ZoneNormaly(c,e,tp) and c:IsType(TYPE_NORMAL)
end
function s.exop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 1 then
		local res1 = Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_MZONE,0,1,nil)
		local res2 = not Duel.IsExistingMatchingCard(s.exfilter2,tp,LOCATION_MZONE,0,1,nil)
		if res1 then
			Scl.SetExtraSelectAndOperateParama("Add2Hand",true)
			Scl.SelectAndOperateCards("Add2Hand",tp,aux.NecroValleyFilter(s.thfilter),tp,"Deck,GY",0,1,1,nil)()
		end
		if res2 then
			Scl.SetExtraSelectAndOperateParama("SpecialSummon",true)
			Scl.SelectAndOperateCards("SpecialSummon",tp,aux.NecroValleyFilter(s.spfilter),tp,"Hand,Deck,GY",0,1,1,nil,e,tp)()
		end
	end
end
function s.tdfilter(c)
	return  (c:IsSetCard(0x6b29) or c:IsType(TYPE_NORMAL)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and Scl.FaceupOrNotBeBanished(c)
end
function s.tdop(e,tp)
	local g = Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if #g > 0 then
		Scl.ShuffleIn2DeckAndDraw(g, nil, 2, tp, 1, REASON_EFFECT, true)
	end
end