function c82228501.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,nil,8,2)  
	c:EnableReviveLimit()  
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228501,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCost(c82228501.thcost)  
	e1:SetTarget(c82228501.thtg)  
	e1:SetOperation(c82228501.thop)  
	c:RegisterEffect(e1)  
	--tohand  
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetDescription(aux.Stringid(82228501,1))  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCountLimit(1,82228501)   
	e2:SetTarget(c82228501.th2tg)  
	e2:SetOperation(c82228501.th2op)  
	c:RegisterEffect(e2)  
end  
function c82228501.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c82228501.thfilter(c)  
	return c:IsSetCard(0x291) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function c82228501.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228501.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228501.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228501.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_FIELD)  
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e1:SetTargetRange(1,0)  
		e1:SetTarget(c82228501.splimit)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		Duel.RegisterEffect(e1,tp)   
	end  
end  
function c82228501.th2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)  
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function c82228501.th2op(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
