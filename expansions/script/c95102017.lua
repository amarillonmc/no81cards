--馄饨食堂
function c95102017.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- 连锁保护
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(95102017,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c95102017.op1)
	c:RegisterEffect(e2)
    -- 卡组检索
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95102017,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c95102017.cost2)
	e3:SetTarget(c95102017.tg2)
	e3:SetOperation(c95102017.op2)
	c:RegisterEffect(e3)
end
-- 1
function c95102017.op1(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xbbc) and ep==tp then
		Duel.SetChainLimit(c95102017.chainlm)
	end
end
function c95102017.chainlm(re,rp,tp)
	return tp==rp or not re:IsActiveType(TYPE_MONSTER)
end
-- 2
function c95102017.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c95102017.filter2(c)
	return c:IsSetCard(0xbbc) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95102017.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95102017.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95102017.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95102017.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
