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
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
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


function s.thfilter(c)
	return s.ForceFighter(c) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)

	if chk == 0 then return Duel.GetMatchingGroupCount(s.thfilter, tp, LOCATION_DECK, 0, nil) >= 3 end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 2, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
	if g:GetCount() >= 3 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)

		local sg = g:Select(tp, 3, 3, nil)
		Duel.ConfirmCards(1 - tp, sg)
		
		Duel.Hint(HINT_SELECTMSG, 1 - tp, HINTMSG_ATOHAND)
		local tg = sg:Select(1 - tp, 1, 1, nil)
		local tc = tg:GetFirst()
		if tc then
			Duel.SendtoHand(tc, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, tc)
			sg:RemoveCard(tc)
		end
		
		if sg:GetCount() > 0 then
			Duel.SendtoDeck(sg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
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
