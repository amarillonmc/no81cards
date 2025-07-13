--微光小队-长天
local s, id = GetID()

function s.initial_effect(c)
 
	-- 效果①：丢弃手卡变更表示形式并特召
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	
	-- 效果②：双方回合作为超量素材
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
end

-- 效果①：丢弃手卡代价
function s.discost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, e:GetHandler()) end
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD, e:GetHandler())
end

-- 效果①：选择场上1只怪兽
function s.distg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk == 0 then
		return Duel.IsExistingTarget(Card.IsCanChangePosition, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) and
			Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
			e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
	local g = Duel.SelectTarget(tp, Card.IsCanChangePosition, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

-- 效果①：变更表示形式并特召
function s.disop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	
	-- 变更目标怪兽表示形式
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc, POS_FACEUP_DEFENSE, POS_FACEUP_ATTACK, POS_FACEUP_ATTACK, POS_FACEUP_DEFENSE)
	end
	
	-- 特殊召唤自身
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end


-- 效果②：选择变更过表示形式的超量怪兽
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsStatus(STATUS_JUST_POS)
end

function s.xyztg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.xyzfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.xyzfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

-- 效果②：作为超量素材并可变更表示形式
function s.xyzop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	local c = e:GetHandler()
	
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		-- 将自身作为超量素材
		if c:IsLocation(LOCATION_REMOVED) then
			Duel.Overlay(tc, Group.FromCards(c))
		end
		
		-- 选择是否变更表示形式
		if tc:IsCanChangePosition() and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end
end
