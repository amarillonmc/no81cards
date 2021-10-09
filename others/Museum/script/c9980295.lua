--超越时空的援军
function c9980295.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980295)
	e1:SetTarget(c9980295.target)
	e1:SetOperation(c9980295.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9980295.mattg)
	e2:SetOperation(c9980295.matop)
	c:RegisterEffect(e2)
end
function c9980295.filter(c)
	return c:IsSetCard(0xbc4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980295.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980295.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980295.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980295.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980295,0))
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980295.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc4) and c:IsType(TYPE_XYZ)
end
function c9980295.matfilter(c)
	return c:IsSetCard(0xbc4) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c9980295.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9980295.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980295.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9980295.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9980295.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980295.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c9980295.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
