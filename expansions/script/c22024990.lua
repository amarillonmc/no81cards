--人理永劫 萨列里
function c22024990.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c22024990.ovfilter,aux.Stringid(22024990,2))
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c22024990.atkval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024990,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,22024990)
	e2:SetCondition(c22024990.negcon)
	e2:SetCost(c22024990.negcost)
	e2:SetTarget(aux.nbtg)
	e2:SetOperation(c22024990.negop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(22024990,1))
	e3:SetCondition(c22024990.negcon1)
	e3:SetCost(c22024990.negcost1)
	c:RegisterEffect(e3)
end
function c22024990.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaff1) and c:IsType(TYPE_LINK)
end
function c22024990.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c22024990.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c22024990.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLink)*200
end
function c22024990.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_LINK)
		and Duel.IsChainDisablable(ev)
end
function c22024990.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22024990.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c22024990.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_LINK)
		and Duel.IsChainDisablable(ev) and e:GetHandler():IsLinkState()
end
function c22024990.negcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end