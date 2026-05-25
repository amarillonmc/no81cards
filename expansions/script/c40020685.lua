--雷翼之神兽 闪电·Z·神鹰
local s, id = GetID()
s.named_with_EmperorBeast=1
function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end
s.ZEUS_CODE = 40020683

function s.initial_effect(c)
	c:EnableReviveLimit()
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMING_END_PHASE)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2a = Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id, 1))
	e2a:SetCategory(CATEGORY_DESTROY)
	e2a:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetCountLimit(1, id+1)
	e2a:SetCondition(s.descon1)
	e2a:SetTarget(s.destg)
	e2a:SetOperation(s.desop)
	c:RegisterEffect(e2a)
	
	local e2b = Effect.CreateEffect(c)
	e2b:SetDescription(aux.Stringid(id, 1))
	e2b:SetCategory(CATEGORY_DESTROY)
	e2b:SetType(EFFECT_TYPE_QUICK_O)
	e2b:SetCode(EVENT_CHAINING)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetCountLimit(1, id+2)
	e2b:SetCondition(s.descon2)
	e2b:SetTarget(s.destg)
	e2b:SetOperation(s.desop)
	c:RegisterEffect(e2b)
	

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0, TIMING_BATTLE_PHASE)
	e3:SetCountLimit(1, {id, 3})
	e3:SetCondition(s.buffcon)
	e3:SetCost(s.spcost)
	e3:SetOperation(s.buffop)
	c:RegisterEffect(e3)
end

function s.costfilter(c)
	return c:IsCode(40020683) and c:IsReleasable()
end
function s.repfilter(c)
	if not c:IsCode(40020683) then return false end
	if not c:IsAbleToGraveAsCost() then return false end
	local loc = c:GetLocation()
	if loc == LOCATION_HAND or loc == LOCATION_DECK then return true end
	if loc == LOCATION_EXTRA  then return c:IsFaceup() end
	return false
end

function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local b1 = Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_PZONE, 0, 1, nil)
	local b2 = Duel.IsPlayerAffectedByEffect(tp, 40020683)
		and Duel.GetFlagEffect(tp, 40020683) == 0
		and Duel.IsExistingMatchingCard(s.repfilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, nil)
	if chk == 0 then
		return b1 or b2
	end
	if b2 and (not b1 or Duel.SelectYesNo(tp, aux.Stringid(40020683, 0))) then
		Duel.RegisterFlagEffect(tp, 40020683, RESET_PHASE + PHASE_END, 0, 1)
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
		local g = Duel.SelectMatchingCard(tp, s.repfilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, 1, nil)
		Duel.SendtoGrave(g, REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
		local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_PZONE, 0, 1, 1, nil)
		Duel.Release(g, REASON_COST)
	end
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, false, true)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:SetMaterial(nil)
		
		if Duel.SpecialSummon(c, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP) > 0 then
			c:CompleteProcedure()
			Duel.BreakEffect()
			Duel.Draw(tp, 1, REASON_EFFECT)
		end
	end
end


function s.descon1(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.descon2(e, tp, eg, ep, ev, re, r, rp)
	return re:IsActiveType(TYPE_MONSTER)
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, 0, LOCATION_MZONE)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	if #g > 0 then
		Duel.Destroy(g, REASON_EFFECT)
	end
end

function s.buffcon(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer() == tp 
		and ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE
end



function s.buffop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
	c:RegisterEffect(e2)
end

function s.damcon(e, tp, eg, ep, ev, re, r, rp)
	local ac = Duel.GetAttacker()
	return ac and ac:IsControler(tp) and s.EmperorBeast(ac)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
	local ac = Duel.GetAttacker()
	if ac then
		local atk = ac:GetAttack()
		if atk <= 0 then
			atk = ac:GetPreviousAttackOnField()
		end
		local dam = math.floor(atk / 2)
		if dam > 0 then
			Duel.Damage(1 - tp, dam, REASON_EFFECT)
		end
	end
end

