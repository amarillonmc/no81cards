--鸟兽气兵 夜枭
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, id + 100)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.cfilter(c)
	return s.ForceFighter(c)  and not c:IsCode(id)
end

function s.spcon(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.tdfilter(c)
	return c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end

function s.setfilter(c)
	return s.ForceFighter(c) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsSSetable()
end

function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.tdfilter, tp, LOCATION_GRAVE + LOCATION_EXTRA, LOCATION_GRAVE + LOCATION_EXTRA, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 0, LOCATION_GRAVE + LOCATION_EXTRA)
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)

	local g = Duel.SelectMatchingCard(tp, s.tdfilter, tp, LOCATION_GRAVE + LOCATION_EXTRA, LOCATION_GRAVE + LOCATION_EXTRA, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.HintSelection(g)

		if Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then

			if Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 
				and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil) 
				and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
				
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)

				local sg = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.setfilter), tp, LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
				if sg:GetCount() > 0 then
					Duel.SSet(tp, sg)
				end
			end
		end
	end
end
