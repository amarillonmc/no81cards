--溶星呼召
local s,id=GetID()


s.named_with_LavaAstral=1
function s.LavaAstral(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_LavaAstral
end

function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP, TIMING_DAMAGE_STEP + TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)


	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end


function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetCurrentPhase() ~= PHASE_DAMAGE or not Duel.IsDamageCalculated()
end

function s.atkfilter(c)
	return s.LavaAstral(c) and c:IsFaceup()
end

function s.pzfilter(c)
	return c:IsCode(40020321) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and not c:IsForbidden()
end

function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.atkfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_ATKCHANGE, nil, 1, tp, 1000)
end

function s.perform_effect_1(e, tp)

	local g = Duel.GetMatchingGroup(s.atkfilter, tp, LOCATION_MZONE, 0, nil)
	if g:GetCount() == 0 then return false end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local tc = g:Select(tp, 1, 1, nil):GetFirst()
	if tc then
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
		
		if Duel.IsExistingMatchingCard(s.pzfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, 1, nil)
			and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) 
			and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then 
			
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
			local pg = Duel.SelectMatchingCard(tp, s.pzfilter, tp, LOCATION_DECK + LOCATION_EXTRA, 0, 1, 1, nil)
			if pg:GetCount() > 0 then
				if Duel.MoveToField(pg:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true) then
					local g2 = Duel.GetMatchingGroup(s.atkfilter, tp, LOCATION_MZONE, 0, nil)
					if g2:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
						Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
						local tc2 = g2:Select(tp, 1, 1, nil):GetFirst()
						if tc2 then
							local e2 = Effect.CreateEffect(e:GetHandler())
							e2:SetType(EFFECT_TYPE_SINGLE)
							e2:SetCode(EFFECT_UPDATE_ATTACK)
							e2:SetValue(1000)
							e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
							tc2:RegisterEffect(e2)
						end
					end
				end
			end
		end
		return true
	end
	return false
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	s.perform_effect_1(e, tp)
end

function s.descon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(Card.IsControler, 1, nil, tp)
end

function s.thfilter(c)
	return s.LavaAstral(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.setfilter(c)
	return s.LavaAstral(c) and c:IsType(TYPE_SPELL + TYPE_TRAP) and not c:IsCode(id) and c:IsSSetable()
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	local b1 = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	local b2 = Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil)
	if chk == 0 then return b1 or b2 end
	
	local cat = 0
	if b1 then cat = cat + CATEGORY_TOHAND + CATEGORY_SEARCH end

	Duel.SetOperationInfo(0, cat, nil, 0, tp, LOCATION_DECK)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local b1 = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	local b2 = Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil) and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	
	if not b1 and not b2 then return end
	
	local op = 0
	if b1 and b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 4), aux.Stringid(id, 5)) 
	elseif b1 then
		op = 0
	else
		op = 1
	end
	
	if op == 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if g:GetCount() > 0 then
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, g)
		end
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
		local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if g:GetCount() > 0 then
			Duel.SSet(tp, g)
		end
	end
	

	local has_target_for_1 = Duel.IsExistingMatchingCard(s.atkfilter, tp, LOCATION_MZONE, 0, 1, nil)
	
	if has_target_for_1 and Duel.SelectYesNo(tp, aux.Stringid(id, 6)) then 
		Duel.BreakEffect()
		s.perform_effect_1(e, tp)
	end
end
