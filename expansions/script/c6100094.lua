--微光小队特遣派送
local s, id = GetID()

function s.initial_effect(c)

	-- 效果①：从卡组送墓微光小队怪兽
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	
	-- 效果②：除外自身特招手卡微光小队怪兽
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- 效果①：目标处理
function s.tgfilter(c)
	return c:IsSetCard(0x961c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

-- 效果①：操作处理
function s.tgop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g == 0 then return end
	
	if Duel.SendtoGrave(g, REASON_EFFECT) > 0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		-- 选择是否变更表示形式
		local sg = Duel.GetMatchingGroup(Card.IsCanChangePosition, tp, LOCATION_MZONE, 0, nil)
		if #sg > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
			local sc = sg:Select(tp, 1, 1, nil):GetFirst()
			if sc then
				Duel.ChangePosition(sc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			end
		end
	end
end

-- 效果②：除外自身作为代价
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

-- 效果②：特招手卡微光小队怪兽
function s.spfilter(c, e, tp)
	return c:IsSetCard(0x961c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_HAND, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

-- 效果②：操作处理
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		local tc = g:GetFirst()
		if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) > 0 then
			-- 选择是否变更表示形式
			if tc:IsCanChangePosition() and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			end
		end
	end
end