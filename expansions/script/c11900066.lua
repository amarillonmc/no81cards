--冥界的仁慈－奈芙蒂丝
function c11900066.initial_effect(c)
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--copy 
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,11900066) 
	e1:SetCost(c11900066.cpcost)
	e1:SetTarget(c11900066.cptg)
	e1:SetOperation(c11900066.cpop)
	c:RegisterEffect(e1)  
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(function(e,c) 
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(LOCATION_GRAVE) end) 
	e2:SetValue(aux.tgoval) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end)
	c:RegisterEffect(e2)
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,11900066) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) end)
	e2:SetTarget(c11900066.thtg) 
	e2:SetOperation(c11900066.thop) 
	c:RegisterEffect(e2) 
end
function c11900066.cpfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:GetActivateEffect()~=nil
end
function c11900066.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end
function c11900066.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c11900066.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11900066.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c11900066.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	local te=tc:GetActivateEffect() 
	if tc:IsRelateToEffect(e) and te then  
		local tg=te:GetTarget()
		if tg(e,tp,eg,ep,ev,re,r,rp,0)==false then return end 
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end   
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end 
end 
function c11900066.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsLevel(9) and c:IsType(TYPE_RITUAL) 
end  
function c11900066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c11900066.thfil,tp,LOCATION_GRAVE,0,1,nil) end 
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11900066.thfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end 
function c11900066.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc)  
	end 
end