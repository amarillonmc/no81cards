--天衍四九风行水上
local s,id,o=GetID()
function s.initial_effect(c)
	--①: 把手卡1张「天衍四九」卡给对方观看才能发动。和给人观看的卡种类不同的2张「天衍四九」卡从卡组加入手卡（相同种类最多1张）。那之后，选那之内1张丢弃
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--②: 这张卡在墓地存在的状态，自己把「天衍四九」怪兽召唤·特殊召唤的场合，把这张卡除外才能发动。从卡组把1张「天衍四九」场地魔法卡在自己场上表侧表示放置
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.setcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	aux.AddThisCardInGraveAlreadyCheck(c)
end
--①: 费用 - 展示手卡1张「天衍四九」卡
function s.costfilter(c,tp)
	if not c:IsSetCard(0x895) or c:IsPublic() then return false end
	local rtype = c:GetType()
	local need_monster = not (rtype & TYPE_MONSTER ~= 0)
	local need_spell = not (rtype & TYPE_SPELL ~= 0)
	local need_trap = not (rtype & TYPE_TRAP ~= 0)
	-- 需要在卡组里能找到与展示种类不同的2种「天衍四九」卡（各1张）
	local g = Duel.GetMatchingGroup(s.deckfilter, tp, LOCATION_DECK, 0, nil, rtype)
	local has_monster = g:IsExists(s.isMonsterType, 1, nil)
	local has_spell = g:IsExists(s.isSpellType, 1, nil)
	local has_trap = g:IsExists(s.isTrapType, 1, nil)
	local count = 0
	if need_monster and has_monster then count = count + 1 end
	if need_spell and has_spell then count = count + 1 end
	if need_trap and has_trap then count = count + 1 end
	return count >= 2
end
function s.isMonsterType(c)
	return c:IsType(TYPE_MONSTER)
end
function s.isSpellType(c)
	return c:IsType(TYPE_SPELL)
end
function s.isTrapType(c)
	return c:IsType(TYPE_TRAP)
end
function s.deckfilter(c,rtype)
	if not c:IsSetCard(0x895) or not c:IsAbleToHand() then return false end
	local ct = c:GetType()
	-- 与展示种类不同
	if (rtype & TYPE_MONSTER ~= 0) and (ct & TYPE_MONSTER ~= 0) then return false end
	if (rtype & TYPE_SPELL ~= 0) and (ct & TYPE_SPELL ~= 0) then return false end
	if (rtype & TYPE_TRAP ~= 0) and (ct & TYPE_TRAP ~= 0) then return false end
	return true
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetType())
end
--①: 目标与处理
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local rtype = e:GetLabel()
	local g = Duel.GetMatchingGroup(s.deckfilter, tp, LOCATION_DECK, 0, nil, rtype)
	if g:GetCount() < 2 then return end
	-- 分别选 1 张与展示种类不同的2种「天衍四九」卡（相同种类最多1张）
	-- 我们按种类分组选 2 种各 1 张
	local added = Group.CreateGroup()
	-- 收集可选的种类
	local types_available = {}
	if (rtype & TYPE_MONSTER == 0) and g:IsExists(s.isMonsterType, 1, nil) then
		table.insert(types_available, TYPE_MONSTER)
	end
	if (rtype & TYPE_SPELL == 0) and g:IsExists(s.isSpellType, 1, nil) then
		table.insert(types_available, TYPE_SPELL)
	end
	if (rtype & TYPE_TRAP == 0) and g:IsExists(s.isTrapType, 1, nil) then
		table.insert(types_available, TYPE_TRAP)
	end
	if #types_available < 2 then return end
	-- 第一种选择
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1 = g:FilterSelect(tp, s.matchType, 1, 1, nil, types_available[1])
	if sg1:GetCount() > 0 then
		added:Merge(sg1)
		g:Sub(sg1)
	end
	-- 第二种选择（剩余种类）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2 = g:FilterSelect(tp, s.matchType, 1, 1, nil, types_available[2])
	if sg2:GetCount() > 0 then
		added:Merge(sg2)
	end
	if added:GetCount() == 2 then
		Duel.SendtoHand(added, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, added)
		Duel.ShuffleHand(tp)
		-- 那之后，选那之内1张丢弃
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp, HINTMSG_DISCARD)
		local dg = added:Select(tp, 1, 1, nil)
		if dg:GetCount() > 0 then
			Duel.SendtoGrave(dg, REASON_EFFECT + REASON_DISCARD)
		end
	end
end
function s.matchType(c, t)
	return (c:GetType() & t) ~= 0
end
--②: 这张卡在墓地存在的状态，自己把「天衍四九」怪兽召唤·特殊召唤的场合
function s.sumcfilter(c, tp)
	return c:IsControler(tp) and c:IsSetCard(0x895) and c:IsType(TYPE_MONSTER)
end
function s.setcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) then return false end
	if not eg:IsExists(s.sumcfilter, 1, nil, tp) then return false end
	if eg:IsContains(c) then return false end
	local reff = c:GetReasonEffect()
	if reff == e then return false end
	return true
end
function s.fieldfilter(c)
	return c:IsSetCard(0x895) and c:IsType(TYPE_FIELD) and not c:IsForbidden()
end
function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.fieldfilter, tp, LOCATION_DECK, 0, 1, nil)
			and Duel.GetFieldCard(tp, LOCATION_FZONE, 0) == nil
	end
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, e:GetHandler(), 1, 0, 0)
end
function s.setop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, s.fieldfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		if not Duel.MoveToField(tc, tp, tp, LOCATION_FZONE, POS_FACEUP, true) then
			Duel.SendtoGrave(tc, REASON_RULE)
		end
	end
end
