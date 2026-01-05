--幸运之女神
local s,id=GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	

	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0, 1)
	e2:SetCondition(s.e2con)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
end

function s.spfilter(c, e, tp)
	return (c:IsCode(40020396) or aux.IsCodeListed(c, 40020396)) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
	
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
	
	local ct = Duel.GetFieldGroupCount(tp, LOCATION_HAND + LOCATION_ONFIELD, 0)
	if ct == 1 then
		e:SetLabel(1)
		local g = Duel.GetMatchingGroup(s.negfilter, tp, 0, LOCATION_MZONE, nil)
		Duel.SetOperationInfo(0, CATEGORY_DISABLE, g, g:GetCount(), 0, 0)
	else
		e:SetLabel(0)
	end
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local stay = not Duel.IsExistingMatchingCard(function(tc) return tc:IsFaceup() and tc:IsCode(id) end, tp, LOCATION_ONFIELD, 0, 1, c)
	if stay and c:IsRelateToEffect(e) then
		c:CancelToGrave()
	end

	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if g:GetCount() > 0 then
		if Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) > 0 then

			if e:GetLabel() == 1 then
				local ng = Duel.GetMatchingGroup(s.negfilter, tp, 0, LOCATION_MZONE, nil)
				if ng:GetCount() > 0 then
					Duel.BreakEffect()
					local tc = ng:GetFirst()
					while tc do
						local e1 = Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
						tc:RegisterEffect(e1)
						local e2 = Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
						tc:RegisterEffect(e2)
						tc = ng:GetNext()
					end
				end
			end
		end
	end
end

function s.cfilter(c)
	return c:IsFaceup() and (c:IsLevelAbove(5) or c:IsRankAbove(5))
		and (c:IsCode(40020396) or aux.IsCodeListed(c, 40020396))
end

function s.e2con(e)
	return Duel.IsExistingMatchingCard(s.cfilter, e:GetHandlerPlayer(), LOCATION_MZONE, 0, 1, nil)
end

function s.aclimit(e, re, tp)
	return re:GetHandler():IsFacedown() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
