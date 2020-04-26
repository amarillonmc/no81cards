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
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910060.discon)
	e2:SetCost(c9910060.discost)
	e2:SetTarget(c9910060.distg)
	e2:SetOperation(c9910060.disop)
	c:RegisterEffect(e2)
end
function c9910060.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c9910060.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
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
	if chk==0 then return Duel.GetFlagEffect(tp,9910060)==0
		and g:IsExists(c9910060.selector,1,nil,tp,g,sg,1) end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c9910060.selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,9910060,RESET_PHASE+PHASE_END,0,1)
end
function c9910060.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c9910060.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainDisablable(ev)
end
function c9910060.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910060.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910060.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	Duel.NegateEffect(ev)
end
