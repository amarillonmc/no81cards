--永恒流星之影炎 凯撒
local s, id = GetID()
function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(46046112)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCountLimit(1, id + 1) 
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e4 = e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e4)
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST)
end

function s.spfilter(c, e, tp)
	return c:IsCode(46046112) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.thfilter(c)
	return c:IsSetCard(0x6f8) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local b1 = Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
		local b2 = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
		local hasCaesar = Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 46046112)
		if hasCaesar then
			return b1 or b2
		else
			return b1
		end
	end
	local b1 = Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	local b2 = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	local hasCaesar = Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 46046112)
	local op = 0
	if hasCaesar and b1 and b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 2), aux.Stringid(id, 3))
	elseif b1 then
		op = 0
	else
		op = 1
	end
	e:SetLabel(op)
	if op == 0 then
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
	else
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	end
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local op = e:GetLabel()
	if op == 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
		if #g > 0 then
			Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #g > 0 then
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, g)
		end
	end
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsLocation(LOCATION_HAND + LOCATION_GRAVE) then return false end
	if bit.band(r, REASON_EFFECT) == 0 then return false end
	if not re or not re:GetHandler():IsSetCard(0x6f8) then return false end
	return true
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