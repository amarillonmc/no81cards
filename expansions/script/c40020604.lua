--鸟兽气兵武神 大和 -武神形-
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end

function s.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, nil, aux.NonTuner(s.matfilter), 1)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DESTROY + CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	--e2:SetCountLimit(1, id + 100)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	local e3 = e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)

	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	--e4:SetCountLimit(1, id + 100)
	e4:SetCondition(s.leavecon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	local e5 = e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end


function s.matfilter(c)
	return s.ForceFighter(c)
end

function s.descon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.desfilter(c, atk)
	return c:IsFaceup() and c:GetAttack() == atk
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
	if chk == 0 then return g:GetCount() > 0 end
	
	local max_atk = g:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
	local tg = g:Filter(s.desfilter, nil, max_atk)
	
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, tg, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, 1-tp, LOCATION_GRAVE)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
	if g:GetCount() > 0 then
		local max_atk = g:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
		local tg = g:Filter(s.desfilter, nil, max_atk)
		if tg:GetCount() > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
			local sg = tg:Select(tp, 1, 1, nil)
			Duel.HintSelection(sg)
			if Duel.Destroy(sg, REASON_EFFECT) > 0 then

				local gy = Duel.GetFieldGroup(tp, 0, LOCATION_GRAVE)
				if gy:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
					Duel.BreakEffect()
					Duel.SendtoDeck(gy, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
				end
			end
		end
	end
end

function s.leavecon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and rp == 1 - tp
end

function s.xyzfilter(c, e, tp)
	return s.ForceFighter(c) and c:IsRank(8) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e, 0, tp, true, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return  Duel.IsExistingMatchingCard(s.xyzfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.xyzfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	local sc = g:GetFirst()
	
	if sc and Duel.SpecialSummon(sc, 0, tp, tp, true, false, POS_FACEUP) > 0 then

		if c:IsRelateToEffect(e) then
			Duel.Overlay(sc, Group.FromCards(c))
		end
	end
end
