--佩涅罗佩[浮游导弹]
local s,id=GetID()
s.named_with_Penelope=1
function s.Penelope(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Penelope
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_POSITION + CATEGORY_HANDES + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_MAIN_END + TIMING_BATTLE_START)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0, LOCATION_MZONE)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0, LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, nil, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(Card.IsCanTurnSet, tp, 0, LOCATION_MZONE, nil)
	
	if g:GetCount() > 0 then
		local num = 1
		if Duel.IsCanRemoveCounter(tp, 1, 0, 0x1f1e, 1, REASON_EFFECT) 
		   and Duel.SelectYesNo(tp, aux.Stringid(id, 5)) then
			Duel.RemoveCounter(tp, 1, 0, 0x1f1e, 1, REASON_EFFECT)
			num = 2
		end
		
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
		local sg = g:Select(tp, 1, num, nil)
		Duel.HintSelection(sg)
		Duel.ChangePosition(sg, POS_FACEDOWN_DEFENSE)
	end

	local b1 = c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) and c:IsDiscardable(REASON_EFFECT)

	local f2 = function(tc)
		if not (tc:IsFaceup() and tc:IsAbleToHand()) and not (tc:IsFaceup() and tc:IsAbleToExtra()) then return false end
		if tc:IsCode(id) then return false end 

		local cond1 = (tc:IsLevelAbove(5) or tc:IsRankAbove(5)) and aux.IsCodeListed(tc, 40020396)

		local cond2 = tc:IsCode(40020406)
		
		return cond1 or cond2
	end
	
	local b2 = c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) 
		   and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		   and Duel.IsExistingMatchingCard(f2, tp, LOCATION_MZONE, 0, 1, nil)
		   and Duel.GetMZoneCount(tp, nil) > 0 
	
	if b1 or b2 then
		Duel.BreakEffect()
		local op = 0
		if b1 and b2 then
			op = Duel.SelectOption(tp, aux.Stringid(id, 3), aux.Stringid(id, 4))
		elseif b1 then
			op = 0
		else
			op = 1
		end
		
		if op == 0 then
			Duel.SendtoGrave(c, REASON_EFFECT + REASON_DISCARD)
		else
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
			local rc = Duel.SelectMatchingCard(tp, f2, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
			if rc then
				local res = 0
				if rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then
					 res = Duel.SendtoDeck(rc, nil, 0, REASON_EFFECT)
				else
					 res = Duel.SendtoHand(rc, nil, REASON_EFFECT)
				end
				
				if res > 0 and (rc:IsLocation(LOCATION_HAND) or rc:IsLocation(LOCATION_EXTRA)) then
					Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
				end
			end
		end
	end
end
