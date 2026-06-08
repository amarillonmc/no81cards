--黑影之皇兽 闪电·Z·国王
local s, id = GetID()

s.named_with_EmperorBeast = 1
function s.EmperorBeast(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

s.ZEUS_CODE = 40020683

function s.initial_effect(c)
	c:EnableReviveLimit()
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2a = Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id, 1))
	e2a:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2a:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetProperty(EFFECT_FLAG_DELAY)
	e2a:SetCountLimit(1, id + 1)
	e2a:SetCondition(s.hspcon)
	e2a:SetTarget(s.hsptg)
	e2a:SetOperation(s.hspop)
	c:RegisterEffect(e2a)
	
	local e2b = Effect.CreateEffect(c)
	e2b:SetDescription(aux.Stringid(id, 1))
	e2b:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_CHAINING)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetCountLimit(1, id + 1)
	e2b:SetCondition(s.hspcon2)
	e2b:SetTarget(s.hsptg)
	e2b:SetOperation(s.hspop)
	c:RegisterEffect(e2b)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id + 2)
	e3:SetCondition(s.damcon)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
function s.costfilter(c)
	return c:IsCode(s.ZEUS_CODE) and c:IsReleasable()
end
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_PZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_PZONE, 0, 1, 1, nil)
	Duel.Release(g, REASON_COST)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, false, true) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:SetMaterial(nil)
	if Duel.SpecialSummon(c, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP) ~= 0 then
		c:CompleteProcedure()
		local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, nil)
		if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISABLE)
			local sg = g:Select(tp, 1, 1, nil)
			local tc = sg:GetFirst()
			Duel.NegateRelatedChain(tc, RESET_TURN_SET)
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT + RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2 = Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT + RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function s.hspcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.hspcon2(e, tp, eg, ep, ev, re, r, rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_SPELL + TYPE_TRAP)
end
function s.hspfilter(c, e, tp)
	if not s.EmperorBeast(c) then return false end
	if c:IsType(TYPE_RITUAL) then
		return c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, false, true)
	else
		return c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
end
function s.hsptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.hspfilter, tp, LOCATION_HAND, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end
function s.hspop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.hspfilter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp)
	local tc = g:GetFirst()
	if tc then
		if tc:IsType(TYPE_RITUAL) then
			tc:SetMaterial(nil)
			if Duel.SpecialSummon(tc, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP) ~= 0 then
				tc:CompleteProcedure()
			end
		else
			Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end
function s.damfilter(c, tp)
	return c:IsType(TYPE_RITUAL) and c:IsControler(tp)
end
function s.damcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.damfilter, 1, nil, tp) and not eg:IsContains(e:GetHandler())
end
function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetTargetPlayer(1 - tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, 1000)
end
function s.damop(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	 Duel.Damage(p, d, REASON_EFFECT)
end
