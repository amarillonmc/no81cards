--妖精騎士
function c88990262.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c88990262.ovfilter,aux.Stringid(88990262,0),3,c88990262.xyzop)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88990262,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c88990262.thcost)
	e1:SetTarget(c88990262.thtg1)
	e1:SetOperation(c88990262.thop1)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88990262,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c88990262.thcost)
	e2:SetTarget(c88990262.thtg2)
	e2:SetOperation(c88990262.thop2)
	c:RegisterEffect(e2)
end
function c88990262.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_XYZ) and not c:IsCode(88990262)
end
function c88990262.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,88990262)==0 end
	Duel.RegisterFlagEffect(tp,88990262,RESET_PHASE+PHASE_END,0,1)
end
function c88990262.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990262.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c88990262.chlimit1)
end
function c88990262.chlimit1(e,ep,tp)
	return tp==ep
end
function c88990262.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c88990262.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c88990262.chlimit2)
end
function c88990262.chlimit2(e,ep,tp)
	return tp==ep
end
function c88990262.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,aux.ExceptThisCard(e))
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
