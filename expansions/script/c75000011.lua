--护花使者 阿尔弗雷德
local m=75000011
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,75000011)
	e1:SetTarget(c75000011.thtg)
	e1:SetOperation(c75000011.thop)
	c:RegisterEffect(e1)
end
function c75000011.thfilter(c)
	return (c:IsCode(75000001) or aux.IsCodeListed(c,75000001) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c75000011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c75000011.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75000011.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c75000011.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75000011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end