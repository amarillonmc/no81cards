--星宫守护者·双鱼
function c72412260.initial_effect(c)
	aux.AddCodeList(c,72412260)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412260,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72412260)
	e1:SetTarget(c72412260.drcost)
	e1:SetTarget(c72412260.drtg)
	e1:SetOperation(c72412260.drop)
	c:RegisterEffect(e1)
			--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412261)
	e2:SetOperation(c72412260.regop)
	c:RegisterEffect(e2)
end
function c72412260.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c72412260.drfilter(c)
	return c:IsSetCard(0x9728) and c:IsAbleToGrave()
end
function c72412260.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412260.drfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and
	Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,nil) 
		end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,1-tp,LOCATION_MZONE)
end
function c72412260.drop(e,tp,eg,ep,ev,re,r,rp)
   local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,1,nil) 
   if dg:GetCount()~=0 and Duel.SendtoHand(dg,tp,REASON_EFFECT)~=0 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.SelectMatchingCard(tp,c72412260.drfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		if g~=0 then
		Group.AddCard(g,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)   
		end
	end
end
function c72412260.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c72412260.thcon)
	e1:SetOperation(c72412260.thop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c72412260.thfilter(c,tp)
	local res=Duel.IsPlayerAffectedByEffect(tp,9911020) and c:IsSetCard(0x9728) and c:IsType(TYPE_MONSTER)
	return (c:IsCode(72412150) or res) and c:IsAbleToHand()
end
function c72412260.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(c72412260.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c72412260.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412260)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72412260.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
