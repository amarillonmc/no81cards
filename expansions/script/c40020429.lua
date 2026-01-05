--雷恩·艾姆

local s,id=GetID()
function s.Penelope(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Penelope
end

function s.initial_effect(c)
	aux.EnableUnionAttribute(c,s.filter)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

end
s.has_text_type=TYPE_UNION
function s.filter(c)
	return s.Penelope(c)
end

function s.spfilter(c, e, tp)
	return s.Penelope(c) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND + LOCATION_GRAVE, 0, 1, nil, e, tp) end
	
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_GRAVE)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)

	local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter), tp, LOCATION_HAND + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	
	if g:GetCount() > 0 then
		if Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) > 0 then

			 if Duel.IsCanRemoveCounter(tp, 1, 0, 0x1f1e, 1, REASON_EFFECT)
			   and Duel.IsPlayerCanDraw(tp, 1)
			   and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
			   
				Duel.BreakEffect()
				if Duel.RemoveCounter(tp, 1, 0, 0x1f1e, 1, REASON_EFFECT) then
					Duel.Draw(tp, 1, REASON_EFFECT)
				end
			end
		end
	end
end