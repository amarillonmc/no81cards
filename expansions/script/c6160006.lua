--破碎世界的幸运轮
function c6160006.initial_effect(c)
	 --to hand
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetCode(EVENT_TO_GRAVE)  
	e1:SetOperation(c6160006.regop)  
	c:RegisterEffect(e1)  
end
	function c6160006.regop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160006,0,1))  
	e1:SetCategory(CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetRange(LOCATION_GRAVE)  
	e1:SetCountLimit(1,6160006)  
	e1:SetTarget(c6160006.thtg)  
	e1:SetOperation(c6160006.thop)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
	c:RegisterEffect(e1)  
end  
function c6160006.thfilter(c,e,tp)  
	return c:IsLevelAbove(3) and c:IsLevelBelow(8) and c:IsRace(RACE_SPELLCASTER)
end
function c6160006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6160006.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6160006.thop(e,tp,eg,ep,ev,te,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6160006.thfilter,tp,LOCATION_DECK,0,1,1,nil) 
	if g:GetCount()>0 then
		 Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	end
end