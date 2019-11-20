--「CR-Unit」整备
function c33400464.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400464)
	e1:SetTarget(c33400464.target)
	e1:SetOperation(c33400464.activate)
	c:RegisterEffect(e1)
	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33400464)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33400464.thtg)
	e2:SetOperation(c33400464.thop)
	c:RegisterEffect(e2)
end
function c33400464.filter(c,tp)
	return c:IsSetCard(0x6343) and c:IsType(TYPE_EQUIP)
end
function c33400464.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE+LOCATION_HAND) and chkc:IsControler(tp) and c33400464.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33400464.filter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33400464.filter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil,tp)
end
function c33400464.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then 
		   Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end

function c33400464.thfilter(c)
	return c:IsSetCard(0x6343) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
	   
end
function c33400464.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400464.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33400464.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33400464.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
