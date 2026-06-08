-- 雷霆魂 超算
local m=26053161
local cm=_G["c"..m]
function cm.initial_effect(c)
local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAIN_DISABLED)  -- 连锁被无效时（对方效果被无效）
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.cond1)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	-- ②效果：这张卡为了发动卡的效果被送去墓地的场合，放置「雷霆」永续魔法
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.cond2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(cm.reg_ret)
	c:RegisterEffect(e3)
end

-- ==================== ①效果 ====================
-- 条件：对方的卡的效果被无效的场合（并且这个无效的连锁是本回合刚发生的）
function cm.cond1(e,tp,eg,ep,ev,re,r,rp)
	-- 检查被无效的那次连锁的发起者是否是对方
	local rc = re:GetHandler()
	return ep == 1-tp and rc:IsControler(1-tp)
end
-- 代价：把手卡的这张卡送去墓地
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST)
end

-- 目标（通常抽卡无目标）
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- 抽1张卡
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Draw(p, d, REASON_EFFECT)
end

-- ==================== ②效果 ====================
-- 条件：这张卡是为发动卡的效果而被送去墓地的场合
-- 备注：需要判断送墓原因中带有 REASON_EFFECT，且是由于效果cost或效果处理导致的。
function cm.cond2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated()
end

-- 目标：从卡组选1张「雷霆」永续魔法卡
function cm.pfilter(c,tp)
	return c:IsAllTypes(TYPE_CONTINUOUS+TYPE_SPELL) and c:IsSetCard(0xeae9)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function cm.thfilter2(c)
	return c:IsAbleToHand()
end
function cm.reg_ret(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.returnop)
	c:RegisterEffect(e1)
end
function cm.returnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_MZONE,0,nil)
			local tg=g:Filter(Card.IsControler,nil,tp)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			end
		end
	end
end