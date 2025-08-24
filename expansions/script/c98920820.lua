--被封印者的魔神右足
local s, id = GetID()
function s.initial_effect(c)
	-- 卡名处理
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_HAND + LOCATION_GRAVE)
	e1:SetValue(8124921) -- 被封印者的右足 ID
	c:RegisterEffect(e1)
  
	-- 丢弃检索效果
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1, id)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
  
	-- 墓地保护效果
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetTarget(s.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
  
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_MZONE, 0)
	e4:SetTarget(s.tglimit)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
end

-- 丢弃代价
function s.discost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST + REASON_DISCARD)
end

-- 检索目标
function s.distg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local b1 = Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
		local b2 = Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil,e,tp)
			and Duel.IsExistingMatchingCard(s.showfilter, tp, LOCATION_HAND, 0, 1, nil)
		return b1 or b2
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, tp, LOCATION_DECK)
end

-- 检索操作
function s.disop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.showfilter, tp, LOCATION_HAND, 0, nil)
  
	if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
		-- 展示手卡中的右足，特殊召唤
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
		local sg = g:Select(tp, 1, 1, nil)
		Duel.ConfirmCards(1 - tp, sg)
	  
		local spg = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_DECK, 0, nil,e,tp)
		if #spg > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local spsg = spg:Select(tp, 1, 2, nil)
			if #spsg > 0 then
				Duel.SpecialSummon(spsg, 0, tp, tp, false, false, POS_FACEUP)
			end
		end
	else
		-- 普通检索
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local tg = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #tg > 0 then
			Duel.SendtoHand(tg, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, tg)
		end
	end
end

-- 过滤器函数
function s.thfilter(c)
	return c:IsCode(8124921) and c:IsAbleToHand()
end

function s.showfilter(c)
	return c:GetOriginalCode()==8124921 and c:IsLocation(LOCATION_HAND)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x40) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.tglimit(e, c)
	return c:IsSetCard(0x40) and c:IsType(TYPE_NORMAL)
end