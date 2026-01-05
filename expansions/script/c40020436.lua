--部队指令
local s,id=GetID()


function s.Hathaway(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Hathaway
end
function s.Penelope(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Penelope
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	

	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)


	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id+100)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0, 1) 
	e3:SetCondition(s.e3con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function s.Penelope(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Penelope
end

function s.Hathaway(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Hathaway
end

function s.filter1(c)
	return s.Penelope(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.filter2(c)
	return c:IsCode(40020429) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end 
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local g1 = Duel.GetMatchingGroup(s.filter1, tp, LOCATION_DECK, 0, nil)
	local g2 = Duel.GetMatchingGroup(s.filter2, tp, LOCATION_DECK, 0, nil)
	

	if g1:GetCount() > 0 and g2:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg1 = g1:Select(tp, 1, 1, nil)
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg2 = g2:Select(tp, 1, 1, nil)
		
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, sg1)
	end
end

function s.tdfilter(c)
	return aux.IsCodeListed(c, 40020396) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk == 0 then return Duel.IsPlayerCanDraw(tp, 1)
		and Duel.IsExistingTarget(s.tdfilter, tp, LOCATION_GRAVE, 0, 3, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, s.tdfilter, tp, LOCATION_GRAVE, 0, 3, 3, nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 3, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local g = tg:Filter(Card.IsRelateToEffect, nil, e)
	if g:GetCount() > 0 then

		if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then

			local og = Duel.GetOperatedGroup()
			if og:IsExists(Card.IsLocation, 1, nil, LOCATION_DECK + LOCATION_EXTRA) then
				if og:IsExists(Card.IsLocation, 1, nil, LOCATION_DECK) then Duel.ShuffleDeck(tp) end
				Duel.Draw(tp, 1, REASON_EFFECT)
			end
		end
	end
end

function s.e3con(e)
	local tp = e:GetHandlerPlayer()
	local ph = Duel.GetCurrentPhase()
	return (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE)
	   and Duel.IsExistingMatchingCard(s.Hathaway, tp, LOCATION_ONFIELD, 0, 1, nil)
end
