--被遗忘的研究 收容物遗忘的记忆
local s, id = GetID()
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c, true, true, s.matfilter1, s.matfilter2)
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_HAND+LOCATION_MZONE,0,aux.ContactFusionSendToDeck(c))
	

	-- 【灵摆效果】：墓地/额外特招
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)

	-- ①：特殊召唤成功时检索
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	--[[ ②：对方怪兽效果发动时（自己的回合）
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id + 2)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)

	-- ③：作为素材或破坏时去灵摆位
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 3))
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.pencon)
	e4:SetTarget(s.pentg2)
	e4:SetOperation(s.penop2)
	c:RegisterEffect(e4)
	local e5 = e4:Clone()
	e5:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e5)
	]]
end



-- 辅助过滤
function s.matfilter1(c) return c:IsSetCard(0x3f13) end
function s.matfilter2(c) return c:IsType(TYPE_PENDULUM) end

-- 接触融合逻辑
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToDeckOrExtraAsCost()
end

-- 【灵摆效果】特招
function s.penfilter(c, e, tp)
	return c:IsSetCard(0x3f13) and (c:IsLocation(LOCATION_GRAVE) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk, chk_target)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingTarget(s.penfilter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, 1, nil, e, tp) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.penfilter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end
function s.penop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
	end
end

-- ① 检索
function s.thfilter(c)
	return c:IsSetCard(0x3f13) and c:IsAbleToHand()
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
		Duel.ConfirmCards(1 - tp, g)
	end
end

-- ② 拦截并特招连接怪
function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
	return ep ~= tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetTurnPlayer() == tp
end
function s.spfilter2(c, e, tp)
	return c:IsSetCard(0x3f13) and c:IsType(TYPE_LINK) and c:GetLink() <= 3
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_GRAVE+LOCATION_EXTRA, 0, 1, nil, e, tp) 
		and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0, CATEGORY_TOEXTRA, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE + LOCATION_EXTRA)
end
function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoExtraP(c, tp, REASON_EFFECT) > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, s.spfilter2, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
		if #g > 0 then
			Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
	-- 自伤限制：只能从额外卡组特招连接怪
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end
function s.splimit(e, c, sump, sumtype, sumpos, targetp, se)
	return not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_EXTRA)
end

-- ③ 放置到灵摆位
function s.pencon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1) end
end
function s.penop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
	end
end