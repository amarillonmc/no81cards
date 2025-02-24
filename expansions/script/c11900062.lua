--生命赐予者－伊西斯
function c11900062.initial_effect(c) 
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--to grave 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,11900062)
	e1:SetCost(c11900062.htgcost)
	e1:SetTarget(c11900062.htgtg) 
	e1:SetOperation(c11900062.htgop) 
	c:RegisterEffect(e1) 
	--to grave
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(11900062,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end)
	c:RegisterEffect(e0)
	--to grave 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11900062,1))
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,11910062) 
	e2:SetCondition(function(e) 
	return e:GetHandler():GetFlagEffect(11900062)>0 end)
	e2:SetTarget(c11900062.tgtg) 
	e2:SetOperation(c11900062.tgop) 
	c:RegisterEffect(e2)  
	--copy 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(11900062,2)) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,11910062)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetFlagEffect(11900062)>0 end)
	e2:SetCost(c11900062.cpcost)
	e2:SetTarget(c11900062.cptg)
	e2:SetOperation(c11900062.cpop)
	c:RegisterEffect(e2) 
end
function c11900062.htgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c11900062.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end 
function c11900062.htgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)  
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT)  
	end 
end 
function c11900062.tgfil(c) 
	return c:IsAbleToGrave() and (c:IsCode(11900061) or (aux.IsCodeListed(c,11900061) and c:IsType(TYPE_MONSTER))) 
end 
function c11900062.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11900062.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c11900062.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11900062.tgfil,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT)  
	end 
end 
function c11900062.cpfilter(c)  
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:GetActivateEffect()~=nil
end
function c11900062.cpcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
end
function c11900062.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingTarget(c11900062.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11900062.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c11900062.cpop(e,tp,eg,ep,ev,re,r,rp)  
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