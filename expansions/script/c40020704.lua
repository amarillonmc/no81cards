--闪电·Z·浣熊
local s, id = GetID()

s.named_with_EmperorBeast = 1
function s.EmperorBeast(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

s.ZEUS_CODE = 40020683

function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.cfilter(c)
	return c:IsFaceup() and s.EmperorBeast(c) and c:GetCode() ~= id
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end

function s.costfilter(c)
	return c:IsFaceup() and s.EmperorBeast(c) and c:IsReleasable()
end

function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		return c:IsReleasable() 
			and Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_MZONE, 0, 1, c)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_MZONE, 0, 1, 1, c)
	g:AddCard(c)
	Duel.Release(g, REASON_COST)
end

function s.zeusfilter(c)
	if not c:IsCode(s.ZEUS_CODE) or not c:IsAbleToHand() then return false end
	local loc = c:GetLocation()
	if loc == LOCATION_HAND or loc == LOCATION_DECK or loc == LOCATION_GRAVE then
		return true
	end
	if loc == LOCATION_EXTRA or loc == LOCATION_REMOVED then
		return c:IsFaceup()
	end
	return false
end

function s.ebfilter(c)
	if not s.EmperorBeast(c) or c:GetCode() == id or not c:IsAbleToHand() then return false end
	local loc = c:GetLocation()
	if loc == LOCATION_HAND or loc == LOCATION_DECK or loc == LOCATION_GRAVE then
		return true
	end
	if loc == LOCATION_EXTRA or loc == LOCATION_REMOVED then
		return c:IsFaceup()
	end
	return false
end

function s.pzonecheck(tp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsCode(s.ZEUS_CODE) end, tp, LOCATION_PZONE, 0, 1, nil)
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local loc = LOCATION_DECK + LOCATION_EXTRA + LOCATION_GRAVE + LOCATION_REMOVED

	local b1 = Duel.IsExistingMatchingCard(s.zeusfilter, tp, loc, 0, 1, nil)

	local b2 = s.pzonecheck(tp) and Duel.IsExistingMatchingCard(s.ebfilter, tp, loc, 0, 1, nil)
	
	if chk == 0 then
		return b1 or b2
	end
	
	local op = 0
	if b1 and b2 then

		if Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			op = 1
		end
	elseif b2 then

		op = 1
	end
	
	e:SetLabel(op)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, loc)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local loc = LOCATION_DECK + LOCATION_EXTRA + LOCATION_GRAVE + LOCATION_REMOVED
	local op = e:GetLabel()
	local g
	if op == 1 then

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		g = Duel.SelectMatchingCard(tp, s.ebfilter, tp, loc, 0, 1, 1, nil)
	else

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		g = Duel.SelectMatchingCard(tp, s.zeusfilter, tp, loc, 0, 1, 1, nil)
	end
	
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end