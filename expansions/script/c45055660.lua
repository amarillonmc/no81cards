--超越星演变
local s, id = GetID()
function s.initial_effect(c)   
	-- ①：二选一特殊召唤效果
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- ②：代替破坏效果
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id+1)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end

-- 效果①：特殊召唤目标
function s.spfilter(c, e, tp)
	return c:IsSetCard(0x6f5) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and c:IsType(TYPE_MONSTER)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local b1 = Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
		
		local g = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_GRAVE, 0, nil, e, tp)
		local b2 = Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
			and g:GetClassCount(Card.GetCode) >= 2
			and not Duel.IsPlayerAffectedByEffect(tp, 59822133)
		
		return b1 or b2 
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	
	-- 重新检查两个选项的条件
	local b1 = Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	
	local g = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_GRAVE, 0, nil, e, tp)
	local b2 = Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
		and g:GetClassCount(Card.GetCode) >= 2
		and not Duel.IsPlayerAffectedByEffect(tp, 59822133)
	
	-- 如果没有可用的选项，直接返回
	if not b1 and not b2 then return end
	
	local op = 0
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 1))
		op = Duel.SelectOption(tp, 
			aux.Stringid(id, 2), -- 从卡组特殊召唤
			aux.Stringid(id, 3)  -- 从墓地特殊召唤
		)
	elseif b1 then
		op = 0
	else
		op = 1
	end
	
	if op == 0 then
		-- 从卡组特殊召唤1只超越星怪兽
		if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
		if g:GetCount() > 0 then
			Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
		end
	else
		-- 从墓地特殊召唤2只超越星怪兽（同名最多1张）
		if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 1 then return end
		if Duel.IsPlayerAffectedByEffect(tp, 59822133) then return end
		
		local g = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_GRAVE, 0, nil, e, tp)
		if g:GetClassCount(Card.GetCode) >= 2 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local tg = g:SelectSubGroup(tp, aux.dncheck, false, 2, 2)
			if tg and tg:GetCount() == 2 then
				Duel.SpecialSummon(tg, 0, tp, tp, false, false, POS_FACEUP)
			end
		end
	end
end
-- 效果②：代替破坏
function s.repfilter(c, tp)
	return c:IsFaceup() and c:IsSetCard(0x6f5) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function s.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter, 1, nil, tp) end
	return Duel.SelectEffectYesNo(tp, e:GetHandler(), aux.Stringid(id, 4))
end

function s.repval(e, c)
	return s.repfilter(c, e:GetHandlerPlayer())
end

function s.repop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_EFFECT + REASON_REPLACE)
end