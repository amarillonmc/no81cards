--Disappear
function c33741059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c33741059.condition)
	e1:SetCost(c33741059.cost)
	e1:SetTarget(c33741059.target)
	e1:SetOperation(c33741059.activate)
	c:RegisterEffect(e1)
end
function c33741059.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_FUSION) and loc==LOCATION_MZONE and Duel.IsChainDisablable(ev)
end
function c33741059.arfilter(c,attr,race)
	return c:IsAttribute(attr) and c:IsRace(race)
end
function c33741059.gcheck(g,fc,attr,race)
	return g:FilterCount(c33741059.arfilter,nil,attr,race)==2 and #g==2 or g:CheckSubGroup(c33741059.mcheck,#g,#g,fc)
end
function c33741059.mcheck(g,fc)
	return fc:CheckFusionMaterial(g,nil,PLAYER_NONE,true)
end
function c33741059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local attr,race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE,CHAININFO_TRIGGERING_RACE)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER):Filter(Card.IsAbleToGraveAsCost,nil)
	if chk==0 then return g:CheckSubGroup(c33741059.gcheck,1,#g,rc,attr,race) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c33741059.gcheck,false,1,#g,rc,attr,race)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c33741059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33741059.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
