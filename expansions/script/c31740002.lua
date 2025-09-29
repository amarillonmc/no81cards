--鬼佛之像
local s,id,o = GetID()
function s.initial_effect(c)
	-- 特殊召唤限制
	aux.AddCodeList(c,31740001)
	c:SetSPSummonOnce(id)
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	c:EnableReviveLimit()
	-- ① 特殊召唤时效果
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TODECK + CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- ② 双方主要阶段特殊召唤"只狼"
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsCode(31740001) or aux.IsCodeListed(c,31740001)
end
-- 特殊召唤限制：只能特殊召唤"只狼"或记述有"只狼"的怪兽
-- 效果①：特殊召唤时发动
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 end
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 0, tp, LOCATION_HAND)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.filter(c)
	return c:IsCode(31740005, 31740006) and c:IsAbleToHand()
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	-- 展示手卡，非"只狼"或记述有"只狼"的卡返回卡组
	local g = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	if #g == 0 then return end
	
	Duel.ConfirmCards(tp, g)
	local tg = g:Filter(s.tdfilter, nil)
	if #tg > 0 then
		Duel.SendtoDeck(tg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
	
	-- 从卡组或墓地选择"楔丸·攻击"和"楔丸·防御"各最多1张加入手卡
	local hg = Duel.GetMatchingGroup(s.filter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, nil)
	if #hg == 0 then return end
	
	local attack = hg:Filter(Card.IsCode, nil, 31740005)
	local defense = hg:Filter(Card.IsCode, nil, 31740006)
	
	local thg = Group.CreateGroup()
	if #attack > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local a = attack:Select(tp, 1, 1, nil)
		thg:Merge(a)
	end
	if #defense > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local d = defense:Select(tp, 1, 1, nil)
		thg:Merge(d)
	end
	
	if #thg > 0 then
		Duel.SendtoHand(thg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, thg)
	end
end

-- 效果②：双方主要阶段特殊召唤"只狼"
function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
	return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
		and Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,0,nil):GetCount()==0
end
function s.seqfilter(c)
	return c:GetSequence()<5
end

function s.tdfilter(c)
	return not (c:IsCode(31740001) or aux.IsCodeListed(c,31740001))
end

function s.spfilter(c, e, tp)
	return c:IsCode(31740001) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetCondition(s.econ)
		e4:SetValue(s.efilter)
		e4:SetTarget(aux.TRUE)
		e4:SetTargetRange(0,LOCATION_ONFIELD)
		Duel.RegisterEffect(e4,tp)
	end
end
function s.efilter(e,re)
	return re:GetHandlerPlayer()==e:GetHandlerPlayer()  and re:IsActivated()
end
function s.econ(e, tp, eg, ep, ev, re, r, rp)
	return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
		
end