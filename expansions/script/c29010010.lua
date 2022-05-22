--方舟之骑士·斯卡蒂
c29010010.named_with_Arknight=1
function c29010010.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010010,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29010010)
	e1:SetCondition(c29010010.thcon)
	e1:SetTarget(c29010010.thtg)
	e1:SetOperation(c29010010.thop)
	c:RegisterEffect(e1) 
	--sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetCondition(c29010010.spcon) 
	e2:SetOperation(c29010010.spop) 
	c:RegisterEffect(e2)
end
function c29010010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c29010010.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_FISH) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29010010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c29010010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29010010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end
function c29010010.spcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,29010010)==0 
end 
function c29010010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.SelectYesNo(tp,aux.Stringid(29010010,0)) then 
	Duel.RegisterFlagEffect(tp,29010010,RESET_PHASE+PHASE_END,0,1)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1000) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	end 
end 



