--被遗忘的研究者 银羽
local s, id = GetID()
function s.initial_effect(c)
	-- ①：展示手牌特招 + 替代效果
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- ②：召、特招成功时特招卡组同名
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

-- 检查是否是“被遗忘的研究”系列卡
function s.is_theme(c)
	return c:IsSetCard(0x3f13) 
end

-- ① 效果 Cost：展示 1 张手牌
function s.costfilter(c)
	return not c:IsPublic()
end
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_HAND, 0, 1, c) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
	local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_HAND, 0, 1, 1, c)
	Duel.ConfirmCards(1 - tp, g)
	-- 记录是否展示了系列卡
	e:SetLabel(s.is_theme(g:GetFirst()) and 1 or 0)
	Duel.ShuffleHand(tp)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		if e:GetLabel() == 1 then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(id)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(LOCATION_MZONE, 0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1, tp)
		end
	end
end

-- 替代效果的判定：检查是否为“被遗忘的研究”连接怪兽
function s.replacetg(e, c)
	return s.is_theme(c) and c:IsType(TYPE_LINK)
end

-- ② 效果：特招卡组/手牌系列怪兽
function s.filter(c, e, tp)
	return s.is_theme(c) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_DECK)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end
