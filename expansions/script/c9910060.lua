--无瑕皎月之月神
function c9910060.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),6,2,c9910060.ovfilter,aux.Stringid(9910060,0),2,c9910060.xyzop)
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
	Duel.AddCustomActivityCounter(9910060,ACTIVITY_CHAIN,c9910060.chainfilter)
end
function c9910060.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_FAIRY) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c9910060.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9951)
end
function c9910060.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c9910060.xyzop(e,tp,chk)
	local g=Duel.GetMatchingGroup(c9910060.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return (Duel.GetCustomActivityCount(9910060,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(9910060,1-tp,ACTIVITY_CHAIN)~=0)
		and Duel.GetFlagEffect(tp,9910060)==0
		and g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,9910060,RESET_PHASE+PHASE_END,0,1)
end
function c9910060.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c9910060.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
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
	Duel.NegateEffect(ev)
end
