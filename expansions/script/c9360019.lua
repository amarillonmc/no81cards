--泛用36计·釜底抽薪
function c9360019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9360019.target)
	e1:SetOperation(c9360019.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9360019)
	e2:SetCost(c9360019.thcost)
	e2:SetTarget(c9360019.thtg)
	e2:SetOperation(c9360019.thop)
	c:RegisterEffect(e2)
end
c9360019.setname="36Stratagems"
function c9360019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetOverlayCount(tp,0,1)~=0 end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9360019.chainlm)
	end
end
function c9360019.chainlm(e,lp,tp)
	local c=e:GetHandler()
	return tp==lp or not c:IsType(TYPE_XYZ)
end
function c9360019.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(tp,0,1)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c9360019.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c9360019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9360019.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end