--永恒流星之炎 凯撒
local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6f8))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(id)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e5)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
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

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	if rp ~= tp then return false end
	if not re:IsActiveType(TYPE_SPELL + TYPE_TRAP) then return false end
	local rc = re:GetHandler()
	return rc and rc:IsSetCard(0x6f8) and rc:IsLocation(LOCATION_ONFIELD)
end

function s.thfilter(c, code)
	return c:IsSetCard(0x6f8) and c:IsAbleToHand() and c:GetCode() ~= code
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local rc = re:GetHandler()
	if not rc then return false end
	local code = rc:GetCode()
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil, code)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	e:SetLabel(code)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local code = e:GetLabel()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.thfilter), tp, LOCATION_DECK, 0, 1, 1, nil, code)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
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