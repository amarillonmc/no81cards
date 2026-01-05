--瞬耀-马夫蒂·纳比尤·艾琳
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
s.named_with_Hathaway=1
function s.Hathaway(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Hathaway
end
function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	
	aux.EnableUnionAttribute(c,s.filter)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.e3con)
	e3:SetValue(3000)
	c:RegisterEffect(e3)
end
s.has_text_type=TYPE_UNION
function s.filter(c)
	return s.XiGundam(c)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)

	if chk == 0 then return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 end
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 1) 
	Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1) 
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE + LOCATION_EXTRA)
end

function s.spfilter(c, e, tp)
	return c:IsCode(40020396) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.xyzfilter(c)
	return s.XiGundam(c) and c:IsXyzSummonable(nil)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local hand = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	if hand:GetCount() == 0 then return end
	
	local ct = Duel.SendtoGrave(hand, REASON_EFFECT + REASON_DISCARD)
	if ct == 0 then return end
	
	local og = Duel.GetOperatedGroup()
	
	if og:IsExists(aux.IsCodeListed, 1, nil, 40020396) then
		local opp_hand = Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND)

		local my_hand = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0)
		local draw_cnt = opp_hand - my_hand
		
		if draw_cnt > 0 then
			Duel.BreakEffect()
			Duel.Draw(tp, draw_cnt, REASON_EFFECT)
		end
	end
	
	
	local b1 = Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
		   and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
		   
	local b2 = Duel.IsExistingMatchingCard(s.xyzfilter, tp, LOCATION_EXTRA, 0, 1, nil)
	
	if (b1 or b2) and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
		Duel.BreakEffect()
		local op = 0
		if b1 and b2 then
			op = Duel.SelectOption(tp, aux.Stringid(id, 2), aux.Stringid(id, 3))
		elseif b1 then
			op = 0
		else
			op = 1
		end
		
		if op == 0 then

			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
			if g:GetCount() > 0 then
				Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
			end
		else

			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local xyz = Duel.SelectMatchingCard(tp, s.xyzfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil):GetFirst()
			if xyz then
				Duel.XyzSummon(tp, xyz, nil)
			end
		end
	end
end

function s.e3con(e)

	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(), 0, LOCATION_ONFIELD) >= 6
end