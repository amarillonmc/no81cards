--怒号光明
c29009961.named_with_Arknight=1
function c29009961.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,29009961)
	e1:SetCondition(c29009961.condition)
	e1:SetTarget(c29009961.target)
	e1:SetOperation(c29009961.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,29009961)
	e2:SetCost(c29009961.cost)
	e2:SetTarget(c29009961.tg)
	e2:SetOperation(c29009961.op)
	c:RegisterEffect(e2)
end
--negate
function c29009961.stf(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29009961.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c29009961.stf,tp,LOCATION_MZONE,0,1,nil)
end
function c29009961.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c29009961.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--Effect 2
function c29009961.csf(c)
	return c29009961.stf(c) and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost())
end
function c29009961.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29009961.csf,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c29009961.csf,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc:IsAbleToExtraAsCost() then
		Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_COST)
	else
		Duel.SendtoHand(tc,nil,REASON_COST)
	end
end
function c29009961.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsAbleToDeck()
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 and b2 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29009961.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
