--桃绯术式 咒刀研磨
function c9910517.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,c9910517.filter,LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910517)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910517)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910517.thtg)
	e2:SetOperation(c9910517.thop)
	c:RegisterEffect(e2)
end
function c9910517.filter(c)
	return c:IsSetCard(0xa950)
end
function c9910517.thfilter(c)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c9910517.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910517.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910517.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9910517.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910517.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
