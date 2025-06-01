--宿敌的记忆
function c95101033.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101033,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,95101033+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c95101033.condition)
	e1:SetTarget(c95101033.target)
	e1:SetOperation(c95101033.activate)
	c:RegisterEffect(e1)
end
function c95101033.condition(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return ep==1-tp and Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,code1,code2)
end
function c95101033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c95101033.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
