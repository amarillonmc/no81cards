--迅捷兔
-- 迅捷兔
local m = 98922035
local cm = _G["c"..m]

function cm.initial_effect(c)
	-- 效果1：从手卡·卡组把「迅捷兔」以外的1只「迅捷」怪兽送去墓地才能发动。从卡组把那只怪兽的1只同名怪兽特殊召唤。
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end

-- 检查是否有可特殊召唤的同名卡
function cm.spfilter(c, code, e, tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

-- 检查是否可以作为Cost送墓
function cm.cfilter(c, e, tp)
	-- 是「迅捷」(0x78)怪兽，不是「迅捷兔」本身
	if not (c:IsSetCard(0x78) and c:IsType(TYPE_MONSTER) and not c:IsCode(m) and c:IsAbleToGraveAsCost()) then return false end
	
	-- 确认送墓后，卡组中至少还有1只同名卡可以特殊召唤
	-- 如果是从卡组送墓，需要排除自身 (通过传入c作为排除对象)
	return Duel.IsExistingMatchingCard(cm.spfilter, tp, LOCATION_DECK, 0, 1, c, c:GetCode(), e, tp)
end

function cm.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
			and Duel.IsExistingMatchingCard(cm.cfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, nil, e, tp) 
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, cm.cfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, 1, nil, e, tp)
	-- 记录被送墓怪兽的卡片密码，以便在效果处理时特殊召唤同名卡
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g, REASON_COST)
end

function cm.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return true -- Cost阶段已经检查过合法性
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function cm.operation(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	local code = e:GetLabel()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, cm.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, code, e, tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end
