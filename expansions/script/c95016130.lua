-- 永续陷阱卡：暗月轮回
local s, id = GetID()

function s.initial_effect(c)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_ACTIVATE)
	e01:SetCode(EVENT_FREE_CHAIN)
	e01:SetCountLimit(1,id+2,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e01)
	
	-- 特殊发动条件：把自己场上1只怪兽除外的场合，这张卡的发动从手卡也能用
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(s.handcost)
	c:RegisterEffect(e0)
	
	-- 效果①：自己回合，丢弃1张手卡，回收墓地暗月卡并抽卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tdcon1)
	e1:SetCost(s.tdcost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	
	-- 效果②：对方回合，无效对方魔法·陷阱卡并双方除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end

-- 定义暗月字段
s.darkmoon_setcode = 0x696c

-- 特殊发动条件：把自己场上1只怪兽除外的场合，这张卡的发动从手卡也能用
function s.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(s.darkmoon_setcode)
end
function s.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end

-- 效果①：自己回合条件
function s.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

-- 效果①：代价（丢弃1张手卡）
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

-- 效果①：目标设定
function s.tdfilter(c)
	return c:IsSetCard(s.darkmoon_setcode) and c:IsAbleToDeck()
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,2,nil)
			and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- 效果①：操作处理
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==2 then
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			if og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==2 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

-- 效果②：对方回合条件
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end

-- 效果②：目标设定
function s.disfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsDisabled()
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and s.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.disfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.disfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end

-- 效果②：操作处理
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		-- 效果无效化
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		
		Duel.BreakEffect()
		
		-- 把这张卡和作为对象的卡除外
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local rg=Group.FromCards(c,tc)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end