--奈芙提斯的呼唤者
-- 奈芙提斯超量
local s, id = GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,2)
	
	-- ①：这张卡超量召唤的场合才能发动。从卡组把1张仪式魔法卡或「奈芙提斯」魔法·陷阱卡加入手卡。
	-- 如果加入的卡不是「奈芙提斯」卡，直到回合结束不能发动该卡及其同名卡的效果。
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id) -- 使用 id 共享一回合一次的限制
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- ②：对方把魔法·陷阱·怪兽的效果发动时，把这张卡1个超量素材取除才能发动。
	-- 把自己的1张手卡和对方场上的1只怪兽破坏。
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id) -- 使用 id 共享一回合一次的限制
	e2:SetCondition(s.descon)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
   	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_OVERLAY_RITUAL_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

-- ① 效果的条件：必须是超量召唤成功
function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

-- ① 效果的检索过滤器
function s.thfilter(c)
	return c:IsAbleToHand() and (
		(c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL)) -- 仪式魔法
		or (c:IsSetCard(0x11f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))) -- 奈芙提斯 魔法/陷阱
	)
end

-- ① 效果的目标
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- ① 效果的运行
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		local tc = g:GetFirst()
		if Duel.SendtoHand(tc, nil, REASON_EFFECT) > 0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp, tc)
			-- 如果加入的卡不是「奈芙提斯」（0x11f）卡
			if not tc:IsSetCard(0x11f) then
				-- 玩家直到回合结束不能发动该卡及其同名卡的效果
				local e1 = Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
				e1:SetDescription(aux.Stringid(id, 2)) -- 提示“不能发动同名卡的效果”
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1, 0)
				e1:SetValue(s.aclimit)
				e1:SetLabel(tc:GetCode())
				e1:SetReset(RESET_PHASE + PHASE_END)
				Duel.RegisterEffect(e1, tp)
			end
		end
	end
end

-- 同名卡发动限制
function s.aclimit(e, re, tp)
	return re:GetHandler():IsCode(e:GetLabel())
end

-- ② 效果的条件：对方发动效果时
function s.descon(e, tp, eg, ep, ev, re, r, rp)
	return rp ~= tp
end

-- ② 效果的Cost：去除一个超量素材
function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

-- ② 效果对方怪兽过滤器 (不使用 IsMonster，改用 IsType)
function s.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end

-- ② 效果的目标
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then 
		return Duel.IsExistingMatchingCard(nil, tp, LOCATION_HAND, 0, 1, nil) -- 自己有手卡
			and Duel.IsExistingMatchingCard(s.desfilter, tp, 0, LOCATION_MZONE, 1, nil) -- 对方场上有怪兽
	end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 2, tp, LOCATION_HAND + LOCATION_MZONE)
end

-- ② 效果的运行（非限定对象的破坏）
function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local g1 = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	local g2 = Duel.GetMatchingGroup(s.desfilter, tp, 0, LOCATION_MZONE, nil)
	if #g1 == 0 or #g2 == 0 then return end
	
	-- 选自己手卡
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local sg1 = g1:Select(tp, 1, 1, nil)
	
	-- 选对方场上怪兽
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local sg2 = g2:Select(tp, 1, 1, nil)
	
	sg1:Merge(sg2)
	Duel.HintSelection(sg2) -- 在场上亮出被选择破坏的对方怪兽
	Duel.Destroy(sg1, REASON_EFFECT)
end
