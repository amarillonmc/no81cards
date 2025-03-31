--星宫潜伏者·蛇夫
function c72421260.initial_effect(c)
			--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,72421260)
	e1:SetOperation(c72421260.regop)
	c:RegisterEffect(e1)	
end
function c72421260.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c72421260.thcon)
	e1:SetOperation(c72421260.thop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c72421260.thfilter(c,tp)
	return c:IsSetCard(0x9728) and c:IsAbleToHand()
end
function c72421260.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(c72421260.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c72421260.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72421260)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72421260.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end