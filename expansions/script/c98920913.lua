--光道布施者 亚拿妮亚
local s, id = GetID()

function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT),2,2,s.lcheck)
	c:EnableReviveLimit()
	
	-- ①：这张卡连接召唤的场合，或者这张卡已在怪兽区域存在的状态，自己场上有这张卡以外的光属性怪兽特殊召唤的场合必定发动。从自己卡组上面把2张卡送去墓地。
	-- 连接召唤成功的场合
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.millcond1)
	e1:SetTarget(s.milltg)
	e1:SetOperation(s.millop)
	c:RegisterEffect(e1)
	
	-- 已在场上存在，其他光属性特殊召唤的场合
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetCondition(s.millcond2)
	e2:SetTarget(s.milltg)
	e2:SetOperation(s.millop)
	c:RegisterEffect(e2)
	
	-- ②：自己卡组的卡被效果送去墓地的场合，以那之内的「光道」怪兽任意数量为对象才能发动（相同种族最多1只）。那些怪兽加入手卡。
	-- 这次决斗中，这个卡名的这个效果不能再以相同种族的怪兽为对象。
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id + 100)
	e3:SetCondition(s.thcond)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

-- 连接材质过滤
function s.matfilter(c, lc, sumtype, tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT, lc, sumtype, tp)
end

-- 连接材质检查（必须包含光道）
function s.lcheck(g, lc, sumtype, tp)
	return g:IsExists(Card.IsSetCard, 1, nil, 0x38, lc, sumtype, tp)
end

-- ① 效果条件1：自身连接召唤成功
function s.millcond1(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

-- ① 效果条件2：其他光属性怪兽在自己场上特召
function s.cfilter(c, tp)
	return c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function s.millcond2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return not eg:IsContains(c) and eg:IsExists(s.cfilter, 1, nil, tp)
end

-- ① 效果执行（堆墓2张）
function s.milltg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DECKDES, nil, 0, tp, 2)
end
function s.millop(e, tp, eg, ep, ev, re, r, rp)
	Duel.DiscardDeck(tp, 2, REASON_EFFECT)
end

-- 决斗全局种族标记器
function s.get_used_races(tp)
	if Duel.GetFlagEffect(tp, id) == 0 then return 0 end
	return Duel.GetFlagEffectLabel(tp, id)
end
function s.add_used_races(tp, race_mask)
	local label = s.get_used_races(tp)
	if Duel.GetFlagEffect(tp, id) == 0 then
		Duel.RegisterFlagEffect(tp, id, 0, 0, 1, bit.bor(label, race_mask))
	else
		Duel.SetFlagEffectLabel(tp, id, bit.bor(label, race_mask))
	end
end

-- ② 效果条件：卡组的卡因效果送去墓地
function s.tgfilter(c, tp, re, used_mask)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler() == tp
		and c:IsLocation(LOCATION_GRAVE) and re and bit.band(c:GetReason(), REASON_EFFECT) ~= 0
		and c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER)
		and bit.band(c:GetRace(), used_mask) == 0
end
function s.thcond(e, tp, eg, ep, ev, re, r, rp)
	local used_mask = s.get_used_races(tp)
	return eg:IsExists(s.tgfilter, 1, nil, tp, re, used_mask)
end

-- 用于选择目标的过滤器（单卡检查）
function s.filter1(c, e, tp, re, used_mask)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler() == tp
		and c:IsLocation(LOCATION_GRAVE) and re and bit.band(c:GetReason(), REASON_EFFECT) ~= 0
		and c:IsSetCard(0x38) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
		and bit.band(c:GetRace(), used_mask) == 0
end

-- 检查选择的多张卡种族各不相同，且均不在已使用种族列表中
function s.subgroup_filter(g, used_mask)
	local mask = used_mask
	for tc in aux.Next(g) do
		local race = tc:GetRace()
		if bit.band(mask, race) ~= 0 then return false end
		mask = bit.bor(mask, race)
	end
	return true
end

-- ② 效果目标选择
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local used_mask = s.get_used_races(tp)
	local g = eg:Filter(s.filter1, nil, e, tp, re, used_mask)
	if chk == 0 then
		return g:GetCount() > 0
	end
	
	-- 首次发动时注册决斗标记
	if Duel.GetFlagEffect(tp, id) == 0 then
		Duel.RegisterFlagEffect(tp, id, 0, 0, 1, 0)
	end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	-- 玩家可以选择任意数量（1张到最大可行张数），要求种族互不相同且未在决斗中被此效果选择过
	local sg = g:SelectSubGroup(tp, s.subgroup_filter, false, 1, g:GetCount(), used_mask)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, sg, sg:GetCount(), 0, 0)
end

-- ② 效果执行
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount() > 0 then
		-- 将本次选择的怪兽的种族加入“已使用种族”位掩码，进行决斗限制
		local race_mask = 0
		for tc in aux.Next(tg) do
			race_mask = bit.bor(race_mask, tc:GetRace())
		end
		s.add_used_races(tp, race_mask)
		
		-- 加入手卡
		Duel.SendtoHand(tg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, tg)
	end
end
