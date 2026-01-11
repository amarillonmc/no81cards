--鸟兽气兵 狐狗狸
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
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DESTROY + CATEGORY_DRAW + CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 100)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

function s.matfilter(c)
	return s.ForceFighter(c)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.spfilter(c, e, tp)

	if c:IsLocation(LOCATION_EXTRA) and not c:IsFaceup() then return false end
	return s.ForceFighter(c) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_PZONE + LOCATION_EXTRA, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_PZONE + LOCATION_EXTRA)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_PZONE + LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end

function s.desfilter(c, atk)
	return c:IsFaceup() and c:GetAttack() == atk
end

function s.yamatofilter(c)
	return c:IsFaceup() and c:IsCode(40020585)
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then
		local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
		local max_atk = g:GetMaxGroup(Card.GetAttack):GetFirst():GetAttack()
		return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.desfilter(chkc, max_atk)
	end
	if chk == 0 then
		local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
		if g:GetCount() == 0 then return false end
		return true
	end
	
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil)
	local max_g = g:GetMaxGroup(Card.GetAttack)
	local max_atk = max_g:GetFirst():GetAttack()

	local tg = g:Filter(s.desfilter, nil, max_atk)
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local sg = tg:Select(tp, 1, 1, nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, sg, 1, 0, 0)
	
	if Duel.IsExistingMatchingCard(s.yamatofilter, tp, LOCATION_PZONE, 0, 1, nil) then
		Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 3)
		Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 2, tp, LOCATION_HAND)

	end
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc, REASON_EFFECT) > 0 then

			if Duel.IsExistingMatchingCard(s.yamatofilter, tp, LOCATION_PZONE, 0, 1, nil) 
				and Duel.IsPlayerCanDraw(tp, 3) then
				
				Duel.BreakEffect()
				if Duel.Draw(tp, 3, REASON_EFFECT) == 3 then
					Duel.ShuffleHand(tp)

					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
					local g = Duel.SelectMatchingCard(tp, Card.IsAbleToDeck, tp, LOCATION_HAND, 0, 2, 2, nil)
					if g:GetCount() > 0 then
						Duel.SendtoDeck(g, nil, SEQ_DECKBOTTOM, REASON_EFFECT)

					end
				end
			end
		end
	end
end
