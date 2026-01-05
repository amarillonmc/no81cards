--冥导龙士 加拉迪亚克
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 0))
	e3:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1, id) 
	e3:SetCondition(s.thcon_gy)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1, id + 1)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

function s.thcon_gy(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function s.thfilter(c)
	return s.InfernalLord(c) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end

function s.cfilter(c)
	return s.InfernalLord(c)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetMatchingGroupCount(s.cfilter, tp, LOCATION_GRAVE, 0, nil) >= 3
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
		and Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 end
	
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 1, tp, 1)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.DiscardHand(tp, nil, 1, 1, REASON_EFFECT + REASON_DISCARD) > 0 then
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
			Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end
