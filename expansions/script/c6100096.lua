--微光小队兵装β-猫柳
local s, id = GetID()

function s.initial_effect(c)
	-- 超量怪兽定义
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)

	-- 效果①：取除素材变更表示形式（快速效果）
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.poscost)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1, false, REGISTER_FLAG_DETACH_XMAT)
	
	-- 效果②：表示形式变更时特殊召唤
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- 超量素材条件：4星怪兽
function s.xyzfilter(c, xyz, sumtype, tp)
	return c:IsSetCard(0x961c) and c:IsLevel(4)
end

-- 效果①：取除素材作为代价
function s.poscost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

-- 效果①：选择场上1只怪兽
function s.postg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsCanChangePosition, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
end

-- 效果①：操作处理
function s.posop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
	local g = Duel.SelectMatchingCard(tp, Card.IsCanChangePosition, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	if #g > 0 then
		Duel.ChangePosition(g, POS_FACEUP_DEFENSE, POS_FACEUP_ATTACK, POS_FACEUP_ATTACK, POS_FACEUP_DEFENSE)
	end
end
function s.cfilter(c,tp,se)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return c:IsControler(tp) and ((pp==0x1 and np==0x4) or (pp==0x4 and np==0x1))
end

-- 效果②：条件检查 - 场上怪兽表示形式变更
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

-- 效果②：目标设置 - 特殊召唤微光小队怪兽
function s.spfilter(c, e, tp)
	return c:IsSetCard(0x961c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

-- 效果②：操作处理 - 特殊召唤
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if #g > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end