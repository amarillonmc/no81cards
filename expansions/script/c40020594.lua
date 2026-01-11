--鸟兽气兵 得手
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end
function s.initial_effect(c)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DRAW + CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_TODECK + CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1, id + 100)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end

function s.yamatofilter(c)
	return c:IsFaceup() and c:IsCode(40020585)
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)

	return Duel.IsExistingMatchingCard(s.yamatofilter, tp, LOCATION_PZONE, 0, 1, nil)
end

function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsPlayerCanDraw(tp, 2) end
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1)
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.Draw(tp, 2, REASON_EFFECT) == 2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		
		local ct = 2
		local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND + LOCATION_ONFIELD)
		if g:GetCount() > 5 then
			ct = 1
		end
		Duel.DiscardHand(tp, nil, ct, ct, REASON_EFFECT + REASON_DISCARD)
	end
end

function s.spfilter(c, e, tp)
	return s.ForceFighter(c) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsAbleToDeck, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, Card.IsAbleToDeck, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 1, 0, 0)

	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc, nil, SEQ_DECKBOTTOM, REASON_EFFECT) > 0 and tc:IsLocation(LOCATION_DECK) then
			local g = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_DECK, 0, nil, e, tp)
			if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and g:GetCount() > 0 
				and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
				
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
				local sg = g:Select(tp, 1, 1, nil)
				if Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP) > 0 then
					local c = e:GetHandler()
					if c:IsRelateToEffect(e) and c:IsFaceup() and not c:IsType(TYPE_TUNER) 
						and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
						local e1 = Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_ADD_TYPE)
						e1:SetValue(TYPE_TUNER)
						e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
						c:RegisterEffect(e1)
					end
				end
			end
		end
	end
end
