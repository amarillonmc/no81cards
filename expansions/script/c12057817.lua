--教导的慵懒美人
function c12057817.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--tg or rm 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057817,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,12057817)
	e1:SetTarget(c12057817.tortg)
	e1:SetOperation(c12057817.torop)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(12057817,2))
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22057817)
	e2:SetCondition(c12057817.thcon)
	e2:SetTarget(c12057817.thtg)  
	e2:SetOperation(c12057817.thop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(12057817,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,32057817)
	e3:SetCondition(c12057817.spcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c12057817.sptg)  
	e3:SetOperation(c12057817.spop)
	c:RegisterEffect(e3)
end
function c12057817.torfil(c)
	return c:IsSetCard(0x145,0x16b) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c12057817.tortg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057817.torfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12057817.torop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057817.torfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local op=3 
	local b1=tc:IsAbleToGrave()
	local b2=tc:IsAbleToRemove()
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057817,0),aux.Stringid(12057817,1))
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057817,0))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057817,1))+1 
	end
	if op==0 then 
	Duel.SendtoGrave(tc,REASON_EFFECT)
	elseif op==1 then 
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c12057817.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c12057817.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x145,0x16b)
end
function c12057817.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057817.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12057817.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057817.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)
	end
end
function c12057817.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c12057817.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x145,0x16b)
end
function c12057817.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057817.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) and Duel.GetMZoneCount(tp,e:GetHandler())>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c12057817.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057817.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler(),e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end





