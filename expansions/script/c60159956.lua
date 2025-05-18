--一只link怪
function c60159956.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--destroy&damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60159956,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60159956)
	e1:SetTarget(c60159956.target)
	e1:SetOperation(c60159956.operation)
	c:RegisterEffect(e1)
	
end

function c60159956.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60159956.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) then
		   local g=Duel.GetOperatedGroup()
		   local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		   if ct==1 and e:GetHandler():IsAbleToExtra() and Duel.SelectYesNo(1-tp,aux.Stringid(60159956,1)) then
				Duel.BreakEffect()
				Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
				Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_EFFECT)
		   end
		end
	end
end