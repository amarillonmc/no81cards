--古斯塔夫·卡尔00型［凯撒利亚搭乘］
local s,id=GetID()

function s.Penelope(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Penelope
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	
	aux.AddXyzProcedure(c, nil, 3, 2)
	c:EnableReviveLimit()

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.e2con)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end


function s.e1cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.thfilter(c)
	return aux.IsCodeListed(c, 40020396) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end

function s.e2con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and s.Penelope(c) end, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.spfilter(c, e, tp)
	return c:IsCode(40020415) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if ft <= 0 then return end
	
	if ft > 2 then ft = 2 end
	if Duel.IsPlayerAffectedByEffect(tp, 59822133) then ft = 1 end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, ft, nil, e, tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end
