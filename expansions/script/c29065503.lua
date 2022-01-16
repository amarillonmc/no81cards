--方舟骑士-煌
c29065503.named_with_Arknight=1
function c29065503.initial_effect(c)
	aux.AddCodeList(c,29065500)
	c:EnableCounterPermit(0x10ae)
	--To hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065503,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,29065503)
	e1:SetTarget(c29065503.thtg)
	e1:SetOperation(c29065503.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	c29065503.summon_effect=e1
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065503,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29065504)
	e3:SetCondition(c29065503.spcon)
	e3:SetTarget(c29065503.sptg)
	e3:SetOperation(c29065503.spop)
	c:RegisterEffect(e3)
	--counter   
	local e4=Effect.CreateEffect(c)   
	e4:SetDescription(aux.Stringid(29065503,2))  
	e4:SetCategory(CATEGORY_COUNTER)	
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)	
	e4:SetProperty((EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL))   
	e4:SetCode(EVENT_LEAVE_FIELD)  
	e4:SetCondition(c29065503.cocon)	
	e4:SetTarget(c29065503.cotg)	
	e4:SetOperation(c29065503.coop)  
	c:RegisterEffect(e4)	
end
function c29065503.thfilter(c,e,tp)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsAbleToHand() and c:IsFaceup()
end
function c29065503.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065503.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c29065503.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065503.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29065503.cfilter(c)
	return c:IsCode(29065500) and c:IsFaceup()
end
function c29065503.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29065503.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c29065503.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29065503.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_DECKBOT)
			c:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
function c29065503.cocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end 
function c29065503.cofilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
 end 
function c29065503.cotg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c29065503.cofilter,tp,LOCATION_ONFIELD,0,1,nil) end 
end
 function c29065503.coop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local tc=Duel.SelectMatchingCard(tp,c29065503.cofilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()	
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x10ae,n)
end