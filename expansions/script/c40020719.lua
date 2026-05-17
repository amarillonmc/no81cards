--反叛之翼 荷鲁阿赫特
local s, id = GetID()

s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end
s.RAHERAKHTY_CODE = 40020713
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

function s.tgcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.thfilter(c)
	return c:IsAbleToHand()
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then

		local hasEmpty = Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		local canReplace = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_SZONE, 0, 1, nil)
		return hasEmpty or canReplace
	end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	

	local hasEmpty = Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	

	if not hasEmpty then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
		local sg = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_SZONE, 0, 1, 1, nil)
		if #sg == 0 then return end
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
	else

		local sg = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_SZONE, 0, nil)
		if #sg > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
			local rg = sg:Select(tp, 1, 1, nil)
			Duel.SendtoHand(rg, nil, REASON_EFFECT)
		end
	end
	

	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	

	Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e1)
	

	Duel.BreakEffect()
	if Duel.IsPlayerCanDraw(tp, 1) and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
		Duel.Draw(tp, 1, REASON_EFFECT)
	end
end


function s.lvfilter(c, tp)

	return c:IsPreviousControler(tp)
		and s.WeaponInsect(c)
		and (c:GetOriginalType() & TYPE_MONSTER) ~= 0
		and c:IsReason(REASON_EFFECT)
		and c:GetReasonPlayer() == 1 - tp
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.lvfilter, 1, nil, tp)
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
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then

		local g = Duel.GetMatchingGroup(Card.IsAbleToDeck, tp, 0, LOCATION_ONFIELD, nil)
		if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 5)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
			local tg = g:Select(tp, 1, 2, nil)
			Duel.SendtoDeck(tg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		end
	end
end
