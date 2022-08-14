--方舟之骑士·斯卡蒂
c29010010.named_with_Arknight=1
function c29010010.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29010010)
	e1:SetCondition(c29010010.spcon)
	e1:SetTarget(c29010010.sptg)
	e1:SetOperation(c29010010.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29010010,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29010010.thtg)
	e2:SetOperation(c29010010.thop)
	c:RegisterEffect(e2) 
	--sp 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,19010010)
	e3:SetCondition(c29010010.spcon2) 
	e3:SetTarget(c29010010.sptg2)
	e3:SetOperation(c29010010.spop2) 
	c:RegisterEffect(e3)
end
function c29010010.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29010010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29010010.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c29010010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29010010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c29010010.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_FISH) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(29010010)
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
function c29010010.spcon2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	return c:IsReason(REASON_DESTROY)  
end 
function c29010010.sptg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c29010010.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
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



