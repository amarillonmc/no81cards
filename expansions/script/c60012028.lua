-- 波摇花的裁决
--Duel.LoadScript("c.lua")
-- 波摇花的裁决
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加波摇花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012027)
	
	-- 反击陷阱的激活效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 可以放置进化指示物的怪兽的过滤
function cm.filter(c)
	return c:IsCanHaveCounter(0x624) and c:IsAbleToHand()
end

-- 触发条件：对方怪兽效果发动
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end

-- 目标函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果执行
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	-- 从卡组找可以放置进化指示物的怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	-- 加入手卡
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	-- 如果加入手卡的怪兽等级高于发动效果的怪兽，就无效并破坏
	if tc:GetLevel()>rc:GetLevel() then
		Duel.NegateEffect(ev)
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
