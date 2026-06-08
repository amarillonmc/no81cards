--三千大世界
local m=43410005
local cm=_G["c"..m]

function cm.initial_effect(c)
	--允许放置「罗生指示物」(0x1fb0)
	c:EnableCounterPermit(0x1fb0)

	--②：作为这张卡发动效果时处理。从卡组把1张「罗生之蝶」卡加入手卡。
	-- (注意：因为文本没有写“可以”，所以发动这张卡的前提是卡组里必须有能检索的卡)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m) -- 这个卡名的②效果1回合只能使用1次
	e1:SetTarget(cm.acttg)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)

	--①：自己把怪兽卡的效果发动时发动。这张卡放置3个罗生指示物。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0)) -- 提示：放置指示物
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) -- 发动时发动 (强制诱发)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)

	--③：场上的「罗生之蝶」怪兽攻击力上升场上罗生指示物的数量×500
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.atktg)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)

	--④：自己场上的「罗生之蝶」怪兽被效果破坏时才能发动。这张卡放置3个罗生指示物。
	-- 那之后，自己可以选对方场上1只怪兽直到结束阶段效果无效。
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1)) -- 提示：破坏时发动
	e4:SetCategory(CATEGORY_COUNTER+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,m+100) -- 这个卡名的④效果1回合只能使用1次
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end

-- ==========================================
-- ②效果：发动与检索
-- ==========================================
function cm.thfilter(c)
	return c:IsSetCard(0xfb0) and c:IsAbleToHand()
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- ==========================================
-- ①效果：怪兽效果发动时强制放置指示物
-- ==========================================
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	-- 是自己发动的，且是怪兽卡的效果
	return rp==tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1fb0,3)
	end
end

-- ==========================================
-- ③效果：根据场上总指示物加攻
-- ==========================================
function cm.atktg(e,c)
	return c:IsSetCard(0xfb0)
end
function cm.atkval(e,c)
	-- 获取全场 (自己和对方场上) 罗生指示物的总数量
	local ct=Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,0x1fb0)
	return ct*500
end

-- ==========================================
-- ④效果：被破坏时放置指示物并无效对方怪兽
-- ==========================================
function cm.desfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSetCard(0xfb0) and c:IsReason(REASON_EFFECT)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.desfilter,1,nil,tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanAddCounter(0x1fb0,3) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x1fb0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:AddCounter(0x1fb0,3) then
		-- 放置成功后，判断对方场上是否有表侧表示的怪兽
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then --在数据库中配置 string 2 为 "是否选对方1只怪兽效果无效？"
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			-- 选怪兽 (不取对象)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.HintSelection(sg)
				-- 赋予无效化效果直到回合结束
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
		end
	end
end