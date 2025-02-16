local s, id = GetID()


function s.initial_effect(c)
	-- 效果①：手卡丢弃发动特召
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id) -- 卡名1回合1次
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果②：召唤/特召变4星
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1) -- 独立次数限制
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

-- 效果① cost丢弃手卡
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST + REASON_DISCARD)
end

-- 效果① 过滤「闡」怪兽
function s.spfilter(c, e, tp)
	return not c:IsCode(id) and c:IsSetCard(0x956) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

-- 效果① 目标检查
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

-- 效果① 执行特召
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end

-- 效果② 等级变更

function s.lvop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		-- 创建永久等级变更效果
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end