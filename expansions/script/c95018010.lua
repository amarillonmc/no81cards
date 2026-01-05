--炽魂·炎拳 雷煌
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

function s.initial_effect(c)
	-- 特殊召唤规则：自己场上有放置炽魂指示物的卡时可以从手卡特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(s.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	-- 添加炽魂指示物
	c:EnableCounterPermit(s.soul_setcode)
	
	-- 效果②：特殊召唤或攻击宣言时添加指示物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e3)
	
	-- 效果③：去除指示物检索
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.thcon)
	e4:SetCost(s.thcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end

-- 效果①：特殊召唤条件
function s.spfilter(c)
	return c:GetCounter(s.soul_setcode)>0
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

-- 效果②：添加指示物条件
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,s.soul_setcode)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(s.soul_setcode,1)
	end
end

-- 效果③：可以在双方回合发动
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
end

-- 效果③：去除指示物作为代价
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST)
end

-- 效果③：检索目标设定
function s.thfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查卡组是否有可检索的卡
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)	
end

-- 效果③：检索操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	-- 从卡组检索炽魂魔法卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			
			-- 检查场上是否有表侧表示的炽魂速攻魔法卡
			local qg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)
			local has_quick=false
			local quick_cards={}
			
			for tc in aux.Next(qg) do
				if tc:IsSetCard(s.soul_setcode) and tc:IsType(TYPE_QUICKPLAY) then
					has_quick=true
					table.insert(quick_cards,tc)
				end
			end
			
			if has_quick then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
				if #dg>0 then
					Duel.BreakEffect()
					Duel.HintSelection(dg)
					Duel.Destroy(dg,REASON_EFFECT)
				end
			end
		end
	end
end