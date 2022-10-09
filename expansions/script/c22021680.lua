--咕哒子-感触虚无
function c22021680.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c22021680.spcon)
	e1:SetOperation(c22021680.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021680,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c22021680.cost)
	e2:SetTarget(c22021680.target)
	e2:SetOperation(c22021680.operation)
	c:RegisterEffect(e2)
end
function c22021680.spfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c22021680.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c22021680.spfilter,1,nil)
end
function c22021680.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c22021680.spfilter,1,1,nil)
	Duel.Hint(HINT_CARD,0,22020000)
	Duel.Release(g,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22021680,1))
	Duel.Hint(HINT_CARD,0,22020600)
	Duel.SelectOption(tp,aux.Stringid(22021680,2))
	Duel.Hint(HINT_CARD,0,22021570)
	Duel.SelectOption(tp,aux.Stringid(22021680,3))
end
function c22021680.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22021680.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c22021680.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end