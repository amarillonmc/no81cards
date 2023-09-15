--端午节的数珠
function c87090002.initial_effect(c)
		--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87090002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,87090002)
	e1:SetCost(c87090002.thcost)
	e1:SetTarget(c87090002.thtg)
	e1:SetOperation(c87090002.thop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(87090002,ACTIVITY_SPSUMMON,c87090002.counterfilter)

end
function c87090002.counterfilter(c)
	return c:IsSetCard(0xafa) 
end
function c87090002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetCustomActivityCount(87090002,tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():IsDiscardable() and Duel.CheckLPCost(tp,1000) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c87090002.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.PayLPCost(tp,1000)
end
function c87090002.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xafa)
end
function c87090002.thfilter(c)
	return c:IsSetCard(0xafa) and c:IsAbleToHand() and not c:IsCode(87090002)
end
function c87090002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87090002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87090002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87090002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end






