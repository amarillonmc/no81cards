--沉醉的古之谣 纯白梦想曲
function c28333723.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28333723.cost)
	e1:SetTarget(c28333723.target)
	e1:SetOperation(c28333723.activate)
	c:RegisterEffect(e1)
	--destory
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c28333723.thtg)
	e2:SetOperation(c28333723.thop)
	c:RegisterEffect(e2)
end
function c28333723.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28333723.desfilter(c,tp,ex)
	local ct=c:IsLevel(3) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and 1 or c:IsControler(tp) and (c:GetType()&TYPE_SPELL+TYPE_FIELD)==TYPE_SPELL+TYPE_FIELD and 2 or c:IsControler(1-tp) and c:GetColumnGroup():IsExists(c28333723.desfilter,1,nil,tp,1) and 3 or 0
	if ex==0 then return ct~=0 else
	return ct==ex end
end
function c28333723.pfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c28333723.gcheck(g,tp)
	return g:IsExists(c28333723.pfilter,1,nil,tp) and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_FZONE)<=1
end
function c28333723.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28333723.desfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,LOCATION_ONFIELD,nil,tp,0)
	if chk==0 then return g:CheckSubGroup(c28333723.gcheck,1,#g,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28333723.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28333723.desfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,LOCATION_ONFIELD,nil,tp,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,c28333723.gcheck,false,1,#g,tp)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c28333723.thfilter(c,chk)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c28333723.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28333723.thfilter,tp,LOCATION_GRAVE,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c28333723.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28333723.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
