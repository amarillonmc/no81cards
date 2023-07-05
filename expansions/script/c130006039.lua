--炼击帝轰临
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local s,id = Scl.SetID(130006039, "LordOfChain")
function s.initial_effect(c)
	local e1 = Scl.CreateSingleBuffCondition(c, "ActivateTrapFromHand", 1, "Hand", s.acon)
	local e2 = Scl.CreateActivateEffect(c, "ActivateEffect", nil, nil, "SpecialSummonFromDeck", nil, s.con, nil, 
		{ "~Target", "SpecialSummon", s.spfilter, "Deck" }, s.act)
	local e3 = Scl.CreateQuickOptionalEffect(c, "FreeChain", "XyzSummon", nil, "XyzSummon", nil, "GY", nil, 
		{ "Cost", "ShuffleIn2Deck", {s.cfilter, s.gcheck}, "Hand,GY", 0, 2 },
		{ "~Target", "XyzSummon", s.xfilter, "Extra" }, s.spop)
end
function s.acon(e)
	return Duel.GetCurrentChain() >= 2
end
function s.con(e)
	return Duel.GetCurrentChain() >= 1
end
function s.spfilter(c,e,tp)
	return Scl.IsCanBeSpecialSummonedNormaly2(c,e,tp) and Scl.IsSeries(c, "LordOfChain")
end
function s.act(e,tp)
	local ct = Duel.GetCurrentChain()
	Scl.SelectAndOperateCards("SpecialSummon", tp, {s.spfilter, aux.dncheck}, tp, "Deck", 0, 1, ct, nil, e, tp)()
end
function s.cfilter(c)
	return c:IsAbleToDeckAsCost() and (not c:IsLocation(LOCATION_HAND) or c:IsPublic())
end
function s.gcheck(g,e,tp)
	return g:IsContains(e:GetHandler()) and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE) < 2
end
function s.xfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil)
end
function s.spop(e,tp)
	local g=Scl.GetMatchingGroup(s.xfilter,tp,"Extra",0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local e1 = Scl.CreateSingleTriggerContinousEffect({e:GetHandler(), tc, true}, "BeXyzSummoned", nil, nil, nil, nil, s.regop, RESETS_SCL)
		Duel.XyzSummon(tp,tc,nil)
	end
end
function s.regop(e,tp)
	Duel.SetChainLimitTillChainEnd(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end