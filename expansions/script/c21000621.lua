local cm, m, o = GetID()

function cm.initial_effect(c)
	-- 永续效果：「森久保」怪兽在场上只能有1只表侧表示存在
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0x61d),LOCATION_MZONE)

	-- 效果1：反转时确认卡并处理
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m, 0))
	e4:SetCategory(CATEGORY_DESTROY + CATEGORY_REMOVE + CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_FLIP)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.flip_target)
	e4:SetOperation(cm.flip_operation)
	c:RegisterEffect(e4)

	-- 效果2：对方发动场上卡效果时反转并破坏卡
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m, 1))
	e5:SetCategory(CATEGORY_DESTROY + CATEGORY_POSITION)
	
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	
	e5:SetCondition(cm.chain_condition)
	e5:SetCost(cm.chain_cost)
	e5:SetTarget(cm.chain_target)
	e5:SetOperation(cm.chain_operation)
	c:RegisterEffect(e5)
end

-- 效果1目标选择
function cm.flip_target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chk == 0 then
		return Duel.IsExistingTarget(Card.IsFacedown, tp, LOCATION_ONFIELD, 0, 1, nil) and
			Duel.IsExistingTarget(nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g1 = Duel.SelectTarget(tp, Card.IsFacedown, tp, LOCATION_ONFIELD, 0, 1, 1, nil)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g2 = Duel.SelectTarget(tp, nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
	local g = g1:Clone()
	g:Merge(g2)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, g, g:GetCount(), 0, 0)
end

-- 效果1操作
function cm.flip_operation(e, tp, eg, ep, ev, re, r, rp)
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local g = tg:Filter(Card.IsRelateToEffect, nil, e)
	if g:GetCount() > 0 then
		-- 确认卡片
		Duel.ConfirmCards(1 - tp, g)
		Duel.ConfirmCards(tp, g)

		-- 分类处理卡片
		local sg = Group.CreateGroup()
		local tg = Group.CreateGroup()
		for tc in aux.Next(g) do
			if (tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x61d)) or (tc:IsType(TYPE_SPELL + TYPE_TRAP) and (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD)) and tc:IsSetCard(0x61d)) then
				sg:AddCard(tc)
			else
				tg:AddCard(tc)
			end
		end

		-- 处理符合条件的卡片（变成表侧表示）
		if sg:GetCount() > 0 then
			for tc in aux.Next(sg) do
				if tc:IsFacedown() then
					Duel.ChangePosition(tc, POS_FACEUP)
				end
			end
		end

		-- 处理不符合条件的卡片（送去墓地）
		if tg:GetCount() > 0 then
			Duel.SendtoGrave(tg, REASON_EFFECT)
		end
	end
end

-- 效果2条件：对方发动场上卡的效果
function cm.chain_condition(e, tp, eg, ep, ev, re, r, rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (LOCATION_ONFIELD)&loc~=0
		and e:GetHandler():IsFacedown()
end

-- 效果2代价：变成表侧守备表示
function cm.chain_cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end

-- 效果2目标选择
function cm.chain_target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingTarget(nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, e:GetHandler())
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

-- 效果2操作
function cm.chain_operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g = Group.FromCards(c, tc)
		Duel.Destroy(g, REASON_EFFECT)
	end
end
