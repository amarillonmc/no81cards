--钢铁方舟·崩岩重锤号
function c29065708.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()  
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29065708)
	e1:SetCost(c29065708.thcost)
	e1:SetTarget(c29065708.thtg)
	e1:SetOperation(c29065708.thop)
	c:RegisterEffect(e1) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c29065708.imcon)
	e1:SetValue(c29065708.efilter)
	c:RegisterEffect(e1)
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0)
	c:RegisterEffect(e1)
end
function c29065708.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x87ac)
end
function c29065708.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065708.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065708.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065708.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c29065708.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c29065708.imfilter(c)
	return c:IsSetCard(0x87ac)
end
function c29065708.imcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c29065708.imfilter,1,nil)
	and e:GetHandler():GetOverlayGroup():FilterCount(c29065708.imfilter,nil)==e:GetHandler():GetOverlayCount()
end
function c29065708.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end