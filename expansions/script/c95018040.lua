--炽魂·瞬影 飞燕
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

function s.initial_effect(c)
	-- 允许放置炽魂指示物
	c:EnableCounterPermit(s.soul_setcode)
	
	-- 效果①：召唤·特殊召唤时放置指示物并检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id) -- 效果①一回合只能使用1次
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	-- 效果②：去除指示物回收并抽卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1) -- 效果②一回合只能使用1次
	e3:SetCondition(s.tdcon)
	e3:SetCost(s.tdcost)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end

-- 效果①：目标设定
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return e:GetHandler():IsCanAddCounter(s.soul_setcode,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,s.soul_setcode)
end

-- 效果①：检索炽魂怪兽的过滤器
function s.thfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

-- 效果①：操作处理
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		-- 放置1个炽魂指示物
		if c:AddCounter(s.soul_setcode,1) then
			-- 从卡组检索1只炽魂怪兽
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end

-- 效果②：发动条件（怪兽在场上）
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end

-- 效果②：去除指示物作为代价
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,s.soul_setcode,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,s.soul_setcode,1,REASON_COST)
end

-- 效果②：目标设定（选择墓地3只炽魂怪兽）
function s.tdfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- 效果②：操作处理
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if #g>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,3,3,nil)
		if #sg==3 then
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
				Duel.ShuffleDeck(tp)
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end