--源石技艺`卷二
function c82567796.initial_effect(c)
	c:EnableCounterPermit(0x5825)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567796,2))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c82567796.ctcon)
	e2:SetCost(c82567796.ctcost)
	e2:SetTarget(c82567796.cttg)
	e2:SetOperation(c82567796.ctop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE+LOCATION_FZONE,0)
	e3:SetTarget(c82567796.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c82567796.filter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567796.costfilter(c)
	return c:IsDiscardable()
end
function c82567796.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567796.filter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.IsExistingMatchingCard(c82567796.costfilter,tp,LOCATION_HAND,0,1,nil)
end
function c82567796.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567796.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c82567796.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c82567796.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x5825,2) and chkc:IsSetCard(0x825) end
	if chk==0 then return Duel.IsExistingTarget(c82567796.filter,tp,LOCATION_MZONE,0,1,nil,0x5825,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567796.filter,tp,LOCATION_MZONE,0,1,1,nil,0x5825,2)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,2)
end
	
function c82567796.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0x825) and tc:IsLocation(LOCATION_MZONE)
  then  tc:AddCounter(0x5825,2)
	end
end
function c82567796.target(e,c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end