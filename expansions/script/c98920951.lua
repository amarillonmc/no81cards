--影霍普

local s, id = GetID()
function c98920951.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff)
	e1:SetValue(0x7f)
	c:RegisterEffect(e1)
	-- 效果①：特殊召唤或作为超量素材
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND + LOCATION_GRAVE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- 效果②：检索拟声卡
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 100)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 效果①条件：检查是否召唤了霍普超量怪兽
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.spxfilter, 1, nil,tp)
end
function s.spxfilter(c,tp)
   return c:IsSetCard(0x7f) and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
-- 效果①目标：选择发动效果
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
	local op = Duel.SelectOption(tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
	e:SetLabel(op)
end

-- 效果①操作：特殊召唤或作为超量素材
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end

	if e:GetLabel() == 0 then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	else
		local tc = eg:GetFirst()
		if tc and tc:IsFaceup() and tc:IsType(TYPE_XYZ) and tc:IsLocation(LOCATION_MZONE) then
			Duel.Overlay(tc, c)
		end
	end
end

-- 效果②代价：支付1000生命值
function s.thcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.CheckLPCost(tp, 1000) end
	Duel.PayLPCost(tp, 1000)
end

-- 效果②目标：检索拟声卡
function s.thfilter(c)
	return c:IsSetCard(0x13a) and not Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, c:GetCode())
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- 效果②操作：将卡加入手牌
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end

