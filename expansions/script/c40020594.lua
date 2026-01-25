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
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 100)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end

function s.spcon(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, c)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
	local g = Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, 1, c)
	local tc = g:GetFirst()
	
	Duel.SendtoGrave(g, REASON_COST + REASON_DISCARD)
	
	if s.ForceFighter(tc) then
		if Duel.IsPlayerCanDraw(tp, 2) and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
			Duel.BreakEffect()
			if Duel.Draw(tp, 2, REASON_EFFECT) == 2 then
				Duel.ShuffleHand(tp)
				Duel.BreakEffect()
				
				local ct = 2
				local g_opp = Duel.GetFieldGroup(tp, 0, LOCATION_HAND + LOCATION_ONFIELD)
				if g_opp:GetCount() > 5 then
					ct = 1
				end
				
				Duel.DiscardHand(tp, nil, ct, ct, REASON_EFFECT + REASON_DISCARD)
			end
		end
	end
end

function s.tdfilter(c)
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end

function s.spfilter2(c, e, tp)
	return s.ForceFighter(c) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)

	if chk == 0 then return Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_GRAVE + LOCATION_EXTRA, LOCATION_GRAVE + LOCATION_EXTRA, 1, nil) end
		
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 0, LOCATION_GRAVE + LOCATION_EXTRA)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)

	local g = Duel.SelectMatchingCard(tp, s.tdfilter, tp, LOCATION_GRAVE + LOCATION_EXTRA, LOCATION_GRAVE + LOCATION_EXTRA, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then
			local tc = g:GetFirst()

			if not (tc:IsLocation(LOCATION_DECK) or tc:IsLocation(LOCATION_EXTRA)) then return end

			local spg = Duel.GetMatchingGroup(s.spfilter2, tp, LOCATION_DECK, 0, nil, e, tp)
			
			if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
				and spg:GetCount() > 0 
				and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then 
				
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
				local sg = spg:Select(tp, 1, 1, nil)
				
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