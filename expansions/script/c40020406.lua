--奥德修斯高达
local s,id=GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_POSITION + CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_DECKDES + CATEGORY_LVLCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id)
	e3:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_MAIN_END + TIMING_BATTLE_START + TIMING_BATTLE_END)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0 
		and e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, e:GetHandler(), 1, 0, 0)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c, POS_FACEUP_DEFENSE)
	end
	
	if Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0 then
		Duel.BreakEffect()
		local tc = Duel.GetDecktopGroup(tp, 1):GetFirst()
		Duel.ConfirmDecktop(tp, 1)
		
		if aux.IsCodeListed(tc, 40020396) then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, tc)
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc, REASON_EFFECT)
		end
		
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e_lvl = Effect.CreateEffect(c)
			e_lvl:SetType(EFFECT_TYPE_SINGLE)
			e_lvl:SetCode(EFFECT_CHANGE_LEVEL)
			e_lvl:SetValue(5)
			e_lvl:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			c:RegisterEffect(e_lvl)
		end
	end
end

function s.e3con(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	local is_main = (ph == PHASE_MAIN1 or ph == PHASE_MAIN2)
	local is_battle = (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE)
	
	return Duel.GetTurnPlayer() == tp and (is_main or is_battle)
end

function s.e3tg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local f = function(c) 
		return aux.IsCodeListed(c, 40020396) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	
	if chk == 0 then return c:IsAbleToHand() 
		and Duel.GetMZoneCount(tp, c) > 0 
		and Duel.IsExistingMatchingCard(f, tp, LOCATION_HAND, 0, 1, nil) end
		
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, c, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.e3op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	if c:IsRelateToEffect(e) and Duel.SendtoHand(c, nil, REASON_EFFECT) > 0 and c:IsLocation(LOCATION_HAND) then

		local f = function(c) 
			return aux.IsCodeListed(c, 40020396) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		end
		
		local g = Duel.GetMatchingGroup(f, tp, LOCATION_HAND, 0, nil)
		if g:GetCount() > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
			if Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
				local sc = g:Select(tp, 1, 1, nil):GetFirst()
				Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP)
			end
		end
	end
end
