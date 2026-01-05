--古斯塔夫·卡尔00型
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

function s.cfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c, 40020396)
end

function s.e1con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.pfilter(c, e, tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevel(3) and aux.IsCodeListed(c, 40020396)
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then 
		return Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2
			and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingMatchingCard(s.pfilter, tp, LOCATION_HAND, 0, 1, c, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_HAND)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2 or not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e, 0, tp, false, false) then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.pfilter, tp, LOCATION_HAND, 0, 1, 1, c, e, tp)
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		
		Duel.SpecialSummonStep(c, 0, tp, tp, false, false, POS_FACEUP)
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(5)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		c:RegisterEffect(e1)
		
		Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(5)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD)
		tc:RegisterEffect(e2)
		
		Duel.SpecialSummonComplete()
	end
end

function s.thfilter(c)
	return aux.IsCodeListed(c, 40020396) and not c:IsCode(id) and c:IsAbleToHand() 
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.thfilter, tp, LOCATION_GRAVE, 0, 1, e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectTarget(tp, s.thfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc, nil, REASON_EFFECT)
	end
end
