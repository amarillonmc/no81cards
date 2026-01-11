local s, id = GetID()
local SET_PATROL_BEE = 0xc328

function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit() 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)

	-- ①：效果组 (2个以上)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1) -- 软限制
	e1:SetCondition(s.effcon1)
	e1:SetTarget(s.efftg1)
	e1:SetOperation(s.effop1)
	c:RegisterEffect(e1)

	-- ①：效果组 (3个以上)
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) -- 软限制
	e2:SetCondition(s.effcon2)
	e2:SetTarget(s.efftg2)
	e2:SetOperation(s.effop2)
	c:RegisterEffect(e2)

	-- ①：效果组 (5个以上)
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 3))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1) -- 软限制
	e3:SetCondition(s.effcon3)
	e3:SetTarget(s.efftg3)
	e3:SetOperation(s.effop3)
	c:RegisterEffect(e3)
end

-- ===========================
-- 自定义超量召唤逻辑
-- ===========================

--xyz
function s.ovfilter1(c)
	return c:IsFaceup() and c:IsLevel(3) and c:IsRace(RACE_INSECT) and c:IsCanOverlay()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.ovfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,0,2,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectMatchingCard(tp,s.ovfilter1,tp,LOCATION_MZONE+LOCATION_SZONE,0,2,63,nil)
	for mc in aux.Next(g) do
		local mg=mc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(c,mg)
		end
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end


-- ===========================
-- 效果①：2个以上 - 补充素材
-- ===========================

function s.effcon1(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetOverlayCount() >= 2
end

function s.matfilter(c)
	return c:IsSetCard(SET_PATROL_BEE)
end

function s.efftg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.matfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id, 1))
end

function s.effop1(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
	local g = Duel.SelectMatchingCard(tp, s.matfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.Overlay(c, g)
	end
end

-- ===========================
-- 效果①：3个以上 - 放置到魔陷区
-- ===========================

function s.effcon2(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetOverlayCount() >= 3
end

-- 检查素材中是否有能放置的“巡猎蜂”
function s.ovfilter(c)
	return c:IsSetCard(SET_PATROL_BEE) 
		and (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_MONSTER))
		and not c:IsForbidden()
end

function s.efftg2(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local og = c:GetOverlayGroup()
	if chk == 0 then 
		return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 
			and og:IsExists(s.ovfilter, 1, nil) 
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id, 2))
end

function s.effop2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local og = c:GetOverlayGroup()
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 or #og == 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local sg = og:FilterSelect(tp, s.ovfilter, 1, 1, nil)
	local tc = sg:GetFirst()
	
	if tc then
		-- 移到魔陷区（自动解除素材状态）
		local move_success = false
		if tc:IsType(TYPE_MONSTER) then
			-- 怪兽变成永续魔法
			if Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
				local e1 = Effect.CreateEffect(c)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL + TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
				move_success = true
			end
		else
			-- 永续魔陷直接放置
			if Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
				move_success = true
			end
		end
	end
end

-- ===========================
-- 效果①：5个以上 - 除外
-- ===========================

function s.effcon3(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():GetOverlayCount() >= 5
end

function s.efftg3(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, nil) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g = Duel.SelectTarget(tp, Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id, 3))
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end

function s.effop3(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc, POS_FACEUP, REASON_EFFECT)
	end
end