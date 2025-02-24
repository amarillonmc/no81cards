--沙海的邪神－塞特
function c11900065.initial_effect(c)
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--copy 
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,11900065) 
	e1:SetCost(c11900065.cpcost)
	e1:SetTarget(c11900065.cptg)
	e1:SetOperation(c11900065.cpop)
	c:RegisterEffect(e1)  
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e2:SetTarget(function(e,c) 
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsSummonLocation(LOCATION_GRAVE) end) 
	e2:SetValue(-800) 
	c:RegisterEffect(e2) 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_GRAVE)  
	e3:SetCountLimit(1,11900065)
	e3:SetCost(c11900065.thcost) 
	e3:SetTarget(c11900065.thtg) 
	e3:SetOperation(c11900065.thop) 
	c:RegisterEffect(e3)
end
function c11900065.cpfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:GetActivateEffect()~=nil
end
function c11900065.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end
function c11900065.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c11900065.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11900065.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c11900065.cpop(e,tp,eg,ep,ev,re,r,rp)  
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
function c11900065.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end 
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST) 
end
function c11900065.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c11900065.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,c)   
	end 
end