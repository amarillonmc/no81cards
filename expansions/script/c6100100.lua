--恩雅-澜风
local s, id = GetID()

function s.initial_effect(c)
	-- 超量召唤条件：相同阶级的超量怪兽×2只以上
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,2)

	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	-- 效果②：取除素材变更表示形式
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.poscost)
	e3:SetTarget(s.postg)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
	
	-- 效果③：表示形式变更时触发效果
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0, LOCATION_MZONE)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.distarget)
	c:RegisterEffect(e4)
	
	--Destroy
	local e6=Effect.CreateEffect(c) 
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e6:SetCode(EVENT_CHANGE_POS)
	e6:SetRange(LOCATION_MZONE) 
	e6:SetOperation(s.deop)
	c:RegisterEffect(e6)

	-- 效果④：破坏有2+启风指示物的怪兽
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id, 1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
end

-- 超量素材检查：相同阶级
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end

-- 效果②：取除素材代价
function s.poscost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

-- 效果②：目标设置
function s.postg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, e:GetHandler(), 1, 0, 0)
end

-- 效果②：变更表示形式
function s.posop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c, POS_FACEUP_DEFENSE, POS_FACEUP_ATTACK, POS_FACEUP_ATTACK, POS_FACEUP_DEFENSE)
	end
end
function s.discon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsAttackPos()
end
function s.deop(e, tp, eg, ep, ev, re, r, rp)

	-- 守备表示效果：变更对方怪兽表示形式并放置指示物
	if e:GetHandler():IsDefensePos() then
		local g = Duel.GetMatchingGroup(nil, 1 - tp, LOCATION_MZONE, 0, nil)
		if #g == 0 then return end
		
		-- 变更表示形式
		Duel.ChangePosition(g, POS_FACEUP_DEFENSE, POS_FACEUP_ATTACK, POS_FACEUP_ATTACK, POS_FACEUP_DEFENSE)
		
		-- 放置启风指示物 (0x961c)
		local tc=g:GetFirst()
		while tc do
		tc:AddCounter(0x961c,2)
		tc=g:GetNext()
		end
	end
end
-- 效果③攻击表示：无效化检查
function s.distarget(e, c)
	return c:GetCounter(0x961c) > 0
end

-- 效果④：目标设置 - 破坏有2+启风指示物的怪兽
function s.desfilter(c)
	return c:GetCounter(0x961c) >= 2
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.desfilter, tp, 0, LOCATION_MZONE, 1, nil) end
	local g = Duel.GetMatchingGroup(s.desfilter, tp, 0, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end

-- 效果④：破坏操作
function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.desfilter, tp, 0, LOCATION_MZONE, nil)
	Duel.Destroy(g, REASON_EFFECT)
end
