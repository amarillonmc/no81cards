--山茶花之寻芳精
function c98876720.initial_effect(c) 
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98876720)
	e1:SetCondition(c98876720.thcon)
	e1:SetTarget(c98876720.thtg)
	e1:SetOperation(c98876720.thop)
	c:RegisterEffect(e1)	 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,18876720)
	e2:SetTarget(c98876720.rmtg)
	e2:SetOperation(c98876720.rmop)
	c:RegisterEffect(e2) 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e3:SetCondition(c98876720.rthcon) 
	e3:SetOperation(c98876720.rthop)
	c:RegisterEffect(e3) 
end
function c98876720.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98876720.thfilter(c)
	return c:IsCode(32441317) and c:IsAbleToHand()
end
function c98876720.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98876720.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98876720.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98876720.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c98876720.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c98876720.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end 
function c98876720.rthfil(c)
	return c:IsSetCard(0x988) and c:IsAbleToHand() 
end
function c98876720.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c98876720.rthfil,tp,LOCATION_GRAVE,0,1,nil) 
	and Duel.GetFlagEffect(tp,98876720)==0 
end
function c98876720.rthop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c98876720.rthfil,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,98876720)==0 and Duel.SelectYesNo(tp,aux.Stringid(98876720,1)) then 
	Duel.Hint(HINT_CARD,0,98876720)  
	Duel.RegisterFlagEffect(tp,98876720,RESET_PHASE+PHASE_END,0,1)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
	local sg=g:Select(tp,1,1,nil)  
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end
end



