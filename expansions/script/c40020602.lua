--气兵之神舞
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end

function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DRAW + CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)


	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end

function s.yamatofilter(c)
	return c:IsFaceup() and c:IsCode(40020585)
end

function s.keepfilter(c)
	return c:IsCode(40020585) or s.ForceFighter(c)
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.yamatofilter, tp, LOCATION_PZONE + LOCATION_EXTRA, 0, 1, nil)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsPlayerCanDraw(tp, 3) end
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 3)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_HAND)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)

	if Duel.Draw(tp, 3, REASON_EFFECT) == 3 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		
		local g = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
		if g:GetCount() < 3 then return end
		
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
		local rg = g:Select(tp, 3, 3, nil)
		Duel.ConfirmCards(1 - tp, rg)
		
		local kable = rg:Filter(s.keepfilter, nil)
		local kg = Group.CreateGroup()
		
		if kable:GetCount() > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 2))
			local max = math.min(2, kable:GetCount())
			kg = kable:Select(tp, 0, max, nil)
		end
		
		rg:Sub(kg)
		if rg:GetCount() > 0 then
			Duel.SendtoDeck(rg, nil, SEQ_DECKBOTTOM, REASON_EFFECT)
		end
	end
end

function s.atkcon(e, tp, eg, ep, ev, re, r, rp)

	local phase = Duel.GetCurrentPhase()
	if phase ~= PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	
	local c = Duel.GetAttacker()
	local tc = Duel.GetAttackTarget()
	if not tc then return false end
	
	if c:IsControler(1-tp) then c = tc end
	
	e:SetLabelObject(c)
	return c:IsControler(tp) and s.ForceFighter(c) and c:IsRelateToBattle()
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local tc = e:GetLabelObject()
	if tc and tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
	end
end
