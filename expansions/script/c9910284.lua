--星幽研究员
function c9910284.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9910284.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9910284.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--rearrange
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910284)
	e2:SetTarget(c9910284.target)
	e2:SetOperation(c9910284.operation)
	c:RegisterEffect(e2)
end
function c9910284.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x957)
end
function c9910284.indtg(e,c)
	return e:GetHandler()==c or (c:IsType(TYPE_PENDULUM) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function c9910284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,4)
	if chk==0 then return g:GetCount()==4 and g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c9910284.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,4)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)
	if tg:GetCount()==0 then return end
	local sg=tg:Select(tp,1,2,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	Duel.ShuffleDeck(1-tp)
end
