--终旅之审判
function c76029010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,76029010+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c76029010.cost)
	e1:SetTarget(c76029010.target)
	e1:SetOperation(c76029010.operation)
	c:RegisterEffect(e1)
end
function c76029010.ctfil(c)
	return c:IsReleasable() and c:IsLevel(7) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
function c76029010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76029010.ctfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c76029010.ctfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_EFFECT)
end
function c76029010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_MZONE,5,nil,ATTRIBUTE_DARK) end 
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_DARK)
	if g:GetCount()==6 then 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,0))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,1))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,2))
	local tc=g:GetFirst()
	local op=3
	while tc do
	Duel.HintSelection(Group.FromCards(tc))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,op))
	op=op+1
	tc=g:GetNext()
	end
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,9))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,10))
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,11))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029010,12))
	end	
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_ONFIELD) 
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c76029010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	Duel.SetLP(tp,Duel.GetLP(tp)/2)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029011,0))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029011,1))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029011,2))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029011,3))
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	e:GetHandler():SetCardData(CARDDATA_CODE,76029011)	
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029011,4))
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(76029011,5))
	end
end







