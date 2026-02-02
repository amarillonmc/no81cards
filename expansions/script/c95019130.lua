--暗牙织夜
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：对方攻击宣言时发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 效果①：发动条件（对方攻击宣言）
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end

-- 效果①：代价（展示手卡1只影牙怪兽）
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
end

-- 代价过滤器（影牙怪兽）
function s.cfilter(c)
	return c:IsSetCard(0xc96c) and c:IsType(TYPE_MONSTER)
end

-- 效果①：目标设定
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then
		return at and at:IsControler(1-tp) and at:IsAbleToDeck()
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,at,1,0,0)
end

-- 效果①：操作处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at and at:IsRelateToBattle() then
		-- 攻击怪兽回到卡组底部
		if Duel.SendtoDeck(at,nil,SEQ_DECKBOTTOM,REASON_EFFECT)~=0 then
			-- 对方从额外卡组随机选1张卡送去墓地
			local opp=1-tp
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,opp,LOCATION_EXTRA,0,nil)
			if #g>0 then
				local tc=g:RandomSelect(opp,1):GetFirst()
				if tc then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
		end
	end
end