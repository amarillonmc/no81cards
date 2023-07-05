--炼击帝赦罪
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local s,id = Scl.SetID(130006038, "LordOfChain")
function s.initial_effect(c)
	local e1 = Scl.CreateActivateEffect(c, "FreeChain", nil, nil, "Send2GY,Draw", "!NegateEffect,!NegateActivation", s.con, nil, 
		{ {"~Target", "Send2GY", Card.IsAbleToGrave, 0, "OnField", s.ct }, 
			{ "PlayerTarget", "Draw", s.ct } }, s.op)
	local e2 = Scl.CreateQuickOptionalEffect(c, "ActivateEffect", "ShuffleIn2Deck", {1, id, "Chain"}, "ShuffleIn2Deck,AddFromDeck2Hand", nil, "Hand", s.scon, nil, s.stg,s.sop)
end
function s.ct(e,tp)
	local g = Scl.GetMatchingGroup(Card.IsPublic, tp, "Hand", 0, e:GetHandler())
	return #g > 0 and 1 or 0
end
function s.con(e,tp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.op(e,tp)
	local g = Scl.GetMatchingGroup(Card.IsPublic, tp, "Hand", 0, nil)
	if #g == 0 then return end
	if Scl.SelectAndOperateCards("Send2GY",tp,Card.IsAbleToGrave,tp,0,"OnField",1,#g,nil)() > 0 then
		local ct = Scl.GetCorrectlyOperatedCount("GY")
		if ct > 0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.scon(e,tp)
	return Duel.GetCurrentChain() >= 2
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tct = Duel.GetMatchingGroupCount(s.thfilter,tp,LOCATION_DECK,0,nil)
	local c = e:GetHandler()
	if chk == 0 then
		return e:IsCostChecked() and not c:IsPublic() and c:IsAbleToDeck() and tct > 0
	end
	local cct = Duel.GetCurrentChain()
	local f1 = function(rc)
		return not rc:IsPublic()
	end
	local f2 = function(g)
		return g:IsContains(c)
	end
	local og = Scl.SelectCards("Reveal",tp,{f1,f2},tp,"Hand",0, 1, math.min(tct, cct), nil)
	Duel.SetTargetCard(og)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,og,#og,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,og,#og,0,0)
end
function s.sop(e,tp)
	local tg = Scl.GetTargetsReleate2Chain()
	if #tg == 0 or Duel.SendtoDeck(tg, nil, 2, REASON_EFFECT) == 0 then return end
	local ct = Scl.GetCorrectlyOperatedCount("Deck")
	if ct == 0 then return end
	Scl.SelectAndOperateCards("Add2Hand",tp,s.thfilter,tp,"Deck",0,ct,ct,nil)()
end
function s.thfilter(c)
	return c:IsAbleToHand() and Scl.IsSeries(c, "LordOfChain") and c:IsType(TYPE_MONSTER)
end