--Destiny Mend
--AlphaKretin
--For Nemoma
local card = c33700407
local code = 33700407
function card.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(card.target)
	e1:SetOperation(card.activate)
	c:RegisterEffect(e1)
end
function card.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local rg = Duel.GetFieldGroup(tp, LOCATION_ONFIELD, 0)
	rg:AddCard(c) --add self to banish check in case in hand
	if chk == 0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 5, c, REASON_EFFECT) and
			rg:IsExists(Card.IsAbleToRemove, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 5, tp, 1)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, rg, #rg, tp, 1)
end
function card.activate(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local dct = Duel.DiscardHand(tp, Card.IsDiscardable, 5, 5, REASON_EFFECT + REASON_DISCARD)
	local rg = Duel.GetFieldGroup(tp, LOCATION_ONFIELD, 0)
	local rct = Duel.Remove(rg, POS_FACEDOWN, REASON_EFFECT)
	if dct > 0 and rct > 0 and rct == #rg then
		local opt = Duel.SelectOption(tp, aux.Stringid(code, 0), aux.Stringid(code, 1), aux.Stringid(code, 2))
		if opt == 0 then
			--double draw
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1, 0)
			e1:SetValue(2)
			Duel.RegisterEffect(e1, tp)
		elseif opt == 1 then
			--double summon
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1, 0)
			e1:SetValue(2)
			Duel.RegisterEffect(e1, tp)
		else
			--double battle
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_BP_TWICE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1, 0)
			Duel.RegisterEffect(e1, tp)
		end
		if rct == 1 and rg:GetFirst() == c then
			local turnp = Duel.GetTurnPlayer()
			Duel.SkipPhase(tp, PHASE_DRAW, RESET_PHASE + PHASE_END, 1)
			Duel.SkipPhase(tp, PHASE_STANDBY, RESET_PHASE + PHASE_END, 1)
			Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE + PHASE_END, 1)
			Duel.SkipPhase(tp, PHASE_BATTLE, RESET_PHASE + PHASE_END, 1, 1)
			Duel.SkipPhase(tp, PHASE_MAIN2, RESET_PHASE + PHASE_END, 1)
			local e1 = Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetTargetRange(1, 0)
			e1:SetReset(RESET_PHASE + PHASE_END)
			Duel.RegisterEffect(e1, turnp)
		end
	end
end
