--皎月之精灵
function c9910060.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,c9910060.ovfilter,aux.Stringid(9910060,0),2,c9910060.xyzop)
	c:EnableReviveLimit()
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c9910060.effcon)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910060.chcon)
	e2:SetCost(c9910060.chcost)
	e2:SetTarget(c9910060.chtg)
	e2:SetOperation(c9910060.chop)
	c:RegisterEffect(e2)
end
function c9910060.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c9910060.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and not c:IsCode(9910060)
end
function c9910060.selector(c,tp,g,sg,i)
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<2 then
		flag=g:IsExists(c9910060.selector,1,nil,tp,g,sg,i+1)
	else
		flag=sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0
			and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c9910060.xyzop(e,tp,chk)
	local g=Duel.GetMatchingGroup(c9910060.cfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	if chk==0 then return g:IsExists(c9910060.selector,1,nil,tp,g,sg,1) end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c9910060.selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c9910060.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c9910060.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c9910060.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910060.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
end
function c9910060.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9910060.repop)
end
function c9910060.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
