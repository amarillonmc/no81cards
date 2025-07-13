--微光小队兵装β-长天
local s, id = GetID()

function s.initial_effect(c)
	-- 超量怪兽定义
	aux.AddXyzProcedure(c,s.mfilter,4,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	
	-- 效果①：对方怪兽效果发动时取除素材反制
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1, false, REGISTER_FLAG_DETACH_XMAT)
	
	-- 效果②：表示形式变更时添加超量素材
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCondition(s.matcon)
	e2:SetTarget(s.mattg)
	e2:SetOperation(s.matop)
	c:RegisterEffect(e2)
end

function s.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x61c) and c:IsStatus(STATUS_JUST_POS)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

-- 效果①：条件检查 - 对方发动怪兽效果
function s.negcon(e, tp, eg, ep, ev, re, r, rp)
	return rp == 1-tp and re:IsActiveType(TYPE_MONSTER)
end

-- 效果①：代价 - 取除1个超量素材
function s.negcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

-- 效果①：目标设置
function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, re:GetHandler(), 1, 0, 0)
end

-- 效果①：操作处理
function s.negop(e, tp, eg, ep, ev, re, r, rp)
	local rc=re:GetHandler()
	 if rc:IsCanChangePosition() and Duel.IsChainDisablable(0) and rc:IsLocation(LOCATION_MZONE)
		and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.ChangePosition(rc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		Duel.NegateEffect(0)
		return
	end
	Duel.NegateEffect(ev)
end
-- 效果②：条件检查 - 场上怪兽表示形式变更
function s.matcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(Card.IsPreviousPosition, 1, nil, POS_FACEUP)
end

-- 效果②：目标设置 - 选择除外的微光小队卡
function s.matfilter(c)
	return c:IsSetCard(0x61c) and c:IsFaceup()
end

function s.mattg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.matfilter, tp, LOCATION_REMOVED, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_LEAVE_REMOVED, nil, 1, tp, LOCATION_REMOVED)
end

-- 效果②：操作处理 - 添加超量素材
function s.matop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
	local g = Duel.SelectMatchingCard(tp, s.matfilter, tp, LOCATION_REMOVED, 0, 1, 1, nil)
	if #g > 0 then
		Duel.Overlay(c, g)
	end
end
