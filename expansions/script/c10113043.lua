--魔法水晶
function c10113043.initial_effect(c)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113043+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10113043.cost)
	e1:SetTarget(c10113043.target)
	e1:SetOperation(c10113043.operation)
	c:RegisterEffect(e1)	
end
function c10113043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c10113043.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c10113043.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10113043.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113043.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,c10113043.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10113043.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	   tc:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000)
	end
end