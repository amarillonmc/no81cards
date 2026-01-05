--冥导皇女 芬莱瑟
local s, id = GetID()
s.named_with_InfernalLord=1
function s.InfernalLord(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_InfernalLord
end

function s.initial_effect(c)
	c:EnableReviveLimit()

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_HANDES + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.spfilter(c, e, tp)
	return s.InfernalLord(c) and not c:IsCode(id) 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc, e, tp) end
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingTarget(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 1, tp, 1)
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 2)

end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	

	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then

		if Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 
		   and Duel.IsPlayerCanDraw(tp, 2) 
		   and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
			local g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_HAND, 0, 1, 1, nil)
			if #g > 0 then
				if Duel.SendtoGrave(g, REASON_EFFECT + REASON_DISCARD) > 0 then
					Duel.Draw(tp, 2, REASON_EFFECT)
				end
			end
		end
	end
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function s.thfilter(c)
	return s.InfernalLord(c) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.thfilter, tp, LOCATION_GRAVE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectTarget(tp, s.thfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc, nil, REASON_EFFECT)
	end
end

