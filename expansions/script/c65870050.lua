--Protoss·灵能反馈
function c65870050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65870050+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65870050.condition)
	e1:SetTarget(c65870050.target)
	e1:SetOperation(c65870050.activate)
	c:RegisterEffect(e1)
end

function c65870050.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3a37) and c:IsLinkAbove(3)
end
function c65870050.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65870050.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and rp==1-tp
end
function c65870050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65870050.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end