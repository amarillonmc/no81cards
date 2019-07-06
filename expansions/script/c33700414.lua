--Rapid Occurence
--AlphaKretin
--For Nemoma
local s = c33700414
local id = 33700414
local CTR = 0x144a
function s.initial_effect(c)
	c:EnableCounterPermit(CTR)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--counter
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(s.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.ctcon)
	e3:SetOperation(s.ctop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--reset
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE + PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.reset)
	c:RegisterEffect(e4)
	--Gain LP
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id, 0))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(s.ctcost)
	e5:SetLabel(3)
	e5:SetTarget(s.lptg)
	e5:SetOperation(s.lpop)
	c:RegisterEffect(e5)
	--Gain ATK
	local e6 = e5:Clone()
	e6:SetDescription(aux.Stringid(id, 1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetLabel(5)
	e6:SetTarget(s.atktg)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
	--Draw
	local e7 = e5:Clone()
	e7:SetDescription(aux.Stringid(id, 2))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetLabel(7)
	e7:SetTarget(s.drtg)
	e7:SetOperation(s.drop)
	c:RegisterEffect(e7)
	--Set LP
	local e7 = e5:Clone()
	e7:SetDescription(aux.Stringid(id, 3))
	e7:SetCategory(0)
	e7:SetLabel(10)
	e7:SetTarget(s.lptg2)
	e7:SetOperation(s.lpop2)
	c:RegisterEffect(e7)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CODE)
	local ac = Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0, CATEGORY_ANNOUNCE, nil, 0, tp, ANNOUNCE_CARD)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local ac = Duel.GetChainInfo(0, CHAININFO_TARGET_PARAM)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD, ac)
	Duel.AdjustInstantly(e:GetHandler())
end
function s.regop(e, tp, eg, ep, ev, re, r, rp)
	if re:GetHandler():GetCode() == e:GetLabelObject():GetLabel() and re:GetHandlerPlayer() == tp then
		e:GetHandler():RegisterFlagEffect(id, RESET_EVENT + 0x1fc0000 + RESET_CHAIN, 0, 1)
		return true
	end
end
function s.ctcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:GetFlagEffect(id) ~= 0 and c:GetFlagEffect(id + 1) < 3 and
		re:GetHandler():GetCode() == e:GetLabelObject():GetLabel()
end
function s.ctop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	c:AddCounter(CTR, 1)
	local ct = c:GetFlagEffect(id + 1)
	c:RegisterFlagEffect(id + 1, RESET_EVENT + RESETS_STANDARD, 0, ct + 1)
end
function s.reset(e, tp, eg, ep, ev, re, r, rp)
	e:GetHandler():ResetFlagEffect(id + 1)
	return false
end
function s.ctcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local ct = e:GetLabel()
	if chk == 0 then
		return c:IsCanRemoveCounter(tp, CTR, ct, REASON_COST)
	end
	c:RemoveCounter(tp, CTR, ct, REASON_COST)
end
function s.lptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 1500)
end
function s.lpop(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Recover(p, d, REASON_EFFECT)
end
function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, nil)
	end
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
	for tc in aux.Next(g) do
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsPlayerCanDraw(tp, 2)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Draw(p, d, REASON_EFFECT)
end
function s.lptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLP(tp) ~= 8000
	end
end
function s.lpop2(e, tp, eg, ep, ev, re, r, rp)
	Duel.SetLP(tp, 8000)
end
