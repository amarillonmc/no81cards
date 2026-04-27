local s, id = GetID()

function s.initial_effect(c)
	-- ①效果：特召并附加自肃；满足条件时发动和效果不会被无效化
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 特召过滤：手卡或卡组「野蛮人」5星怪兽
function s.spfilter(c, e, tp)
	return c:IsSetCard(0x17b) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

-- 目标检查与不会被无效化处理
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	-- 条件：对方场上的卡数量比自己多时，设置不会被无效化与禁止
	if Duel.GetFieldGroupCount(tp, 0, LOCATION_ONFIELD) > Duel.GetFieldGroupCount(tp, LOCATION_ONFIELD, 0) then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e:SetProperty(0)
	end
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_HAND + LOCATION_DECK)
end

-- 效果处理
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end

	local g = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, nil, e, tp)
	if #g == 0 then return end

	-- 选择第一只
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg = Group.CreateGroup()
	local tc1 = g:Select(tp, 1, 1, nil):GetFirst()
	sg:AddCard(tc1)
	g:Remove(Card.IsCode, nil, tc1:GetCode())

	-- 如果还有空位且能选第二只（卡名不同）
	if #g > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local tc2 = g:Select(tp, 0, 1, nil):GetFirst()
		if tc2 then sg:AddCard(tc2) end
	end

	-- 特殊召唤
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
	end
	Duel.SpecialSummonComplete()

	-- 自肃：直到回合结束，不是战士族·地属性不能召唤·特召
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)

	local e2 = e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2, tp)
end

-- 自肃过滤：不是战士族且地属性则不能召唤/特召
function s.sumlimit(e, c)
	return not (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH))
end