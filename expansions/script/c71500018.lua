--
local cm,m=GetID()

function c71500018.initial_effect(c)
	-- 这张卡的发动和效果不会被无效化
	-- 效果①：给予伤害并抽卡
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(cm.cost1)
	e3:SetTarget(cm.target1)
	e3:SetOperation(cm.operation1)
	c:RegisterEffect(e3)

	-- 效果②：回复基本分
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCost(cm.cost2)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.operation2)
	c:RegisterEffect(e4)
end

-- 效果①：Cost
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  re:GetHandler():IsCode(71500018) and re:IsActivated(EFFECT_TYPE_ACTIVATE)  then
	Debug.Message(1)
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

-- 效果①：Target
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsCode(m) then
		Duel.RegisterFlagEffect(tp,m,0,EFFECT_FLAG_OATH,0)
	end
	local ct=Duel.GetFlagEffect(tp,m)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*200+200)
	if ct-2>0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct-3)
	end
end

-- 效果①：Operation
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,m)
	if ct==0 then return end
	-- 给予伤害
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	-- 抽卡
	local draw=math.max(ct-3,0)
	if draw>0 then
		Duel.Draw(tp,draw,REASON_EFFECT)
	end
end

-- 效果②：Cost
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end

-- 效果②：Target
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,m)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1000)
end

-- 效果②：Operation
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,m)
	if ct==0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

-- 记录「璀璨的未来」发动次数的全局函数


