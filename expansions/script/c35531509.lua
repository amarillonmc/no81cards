--灰流丽·带上手铐
function c35531509.initial_effect(c)
	aux.AddCodeList(c,14558127) 
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--lv 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(35531509,1))  
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,35531509)
	e1:SetTarget(c35531509.lvtg) 
	e1:SetOperation(c35531509.lvop) 
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35531509,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15531509)
	e2:SetCost(c35531509.spcost)
	e2:SetTarget(c35531509.sptg)
	e2:SetOperation(c35531509.spop)
	c:RegisterEffect(e2) 
	--des
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,25531509)
	e3:SetCondition(c35531509.descon)
	e3:SetTarget(c35531509.destg)
	e3:SetOperation(c35531509.desop)
	c:RegisterEffect(e3)
end
function c35531509.pbfil(c) 
	return not c:IsPublic() and c:IsAttribute(ATTRIBUTE_FIRE) 
end  
function c35531509.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35531509.pbfil,tp,LOCATION_HAND,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c35531509.pbfil,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc) 
	e:SetLabel(tc:GetLevel()) 
	Duel.ShuffleHand(tp) 
end 
function c35531509.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local lv=e:GetLabel()
	if lv and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_LEVEL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-lv) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
	end 
end 
function c35531509.ctfil(c) 
	return c:IsAbleToHandAsCost() and (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) 
end 
function c35531509.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35531509.ctfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) end 
	local g=Duel.SelectMatchingCard(tp,c35531509.ctfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil) 
	Duel.SendtoHand(g,nil,REASON_COST) 
end 
function c35531509.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c35531509.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c35531509.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c35531509.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35531509.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c35531509.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c35531509.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c35531509.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
end









