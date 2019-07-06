--Backstage Desperation
--AlphaKretin
--For Nemoma
local s = c33700424
local id = 33700424
function s.initial_effect(c)
	--Activate
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Draw in hand
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE + PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.drcon)
	e1:SetCost(s.drcost)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--Count activations/summons while face-up
	local ea = Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	ea:SetRange(LOCATION_SZONE)
	ea:SetCode(EVENT_SUMMON_SUCCESS)
	ea:SetOperation(s.countop)
	c:RegisterEffect(ea)
	local eb = ea:Clone()
	eb:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(eb)
	local ec = ea:Clone()
	ec:SetCode(EVENT_CHAINING)
	c:RegisterEffect(ec)
	--Draw on field
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_TRIGGER_F + EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE + PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1, id)
	e2:SetLabelObject(ea)
	e2:SetCondition(s.drcon2)
	e2:SetTarget(s.drtg2)
	e2:SetOperation(s.drop2)
	c:RegisterEffect(e2)
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
	local eff, ns, ss = Duel.GetActivityCount(tp, ACTIVITY_CHAIN, ACTIVITY_SUMMON, ACTIVITY_SPECIALSUMMON)
	return (eff + ns + ss == 0) and (tp == Duel.GetTurnPlayer())
end

function s.drcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return not c:IsPublic()
	end
	--reveals as part of activation innately
end

function s.drtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsPlayerCanDraw(tp, 1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Draw(p, d, REASON_EFFECT)
end

function s.countop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if rp == tp and (not re or re:GetHandler() ~= c) then
		c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD, 0, 0)
	end
end

function s.drcon2(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetFlagEffect(id) == 0
end

function s.drtg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsPlayerCanDraw(tp, 3)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 3)
end
function s.setfilter(c, tp)
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
			c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEDOWN_DEFENSE)
	else
		return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp, LOCATION_SZONE) > 0) and c:IsSSetable()
	end
end

function s.drop2(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Draw(p, d, REASON_EFFECT)
	local og = Duel.GetOperatedGroup():Filter(s.setfilter, nil, tp)
	local c = e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_ONFIELD, 0, 1, c) and og then
		local cg = Group.CreateGroup()
		while #og > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) do
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
			local tc = og:Select(tp, 1, 1, nil):GetFirst()
			if tc:IsType(TYPE_MONSTER) then
				Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEDOWN_DEFENSE)
			else
				Duel.SSet(tp, tc)
			end
			cg:AddCard(tc)
			og:RemoveCard(tc)
			og = og:Filter(s.setfilter, nil, tp)
		end
		Duel.SpecialSummonComplete()
		Duel.ConfirmCards(1 - tp, cg)
	end
end
