--智慧回响－托特
function c11900080.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,11900061)   
	--to grave  
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11900080) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) end) 
	e1:SetTarget(c11900080.tgtg) 
	e1:SetOperation(c11900080.tgop) 
	c:RegisterEffect(e1) 
	--copy 
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,11900080) 
	e2:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetTurnPlayer()==1-tp end)
	e2:SetCost(c11900080.cpcost)
	e2:SetTarget(c11900080.cptg)
	e2:SetOperation(c11900080.cpop)
	c:RegisterEffect(e2)  
end 
function c11900080.tgfil(c) 
	return (c:IsCode(11900061) or aux.IsCodeListed(c,11900061)) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end 
function c11900080.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c11900080.tgfil,tp,LOCATION_DECK,0,1,nil) end  
	if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c11900080.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11900080.tgfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=g:Select(tp,1,1,nil)
        Duel.SendtoGrave(dg,REASON_EFFECT)
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(11900080,0)) then 
			Duel.BreakEffect()  
			Duel.Draw(tp,1,REASON_EFFECT)
		end 
	end 
end 
function c11900080.cpfilter(c)
	return (c:IsCode(11900061) or aux.IsCodeListed(c,11900061)) and c:IsType(TYPE_SPELL) and c:GetActivateEffect()~=nil
end
function c11900080.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c11900080.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c11900080.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11900080.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():GetActivateEffect() 
end
function c11900080.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	local te=tc:GetActivateEffect() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		if tc:IsRelateToEffect(e) and te then  
			local tg=te:GetTarget()
			if tg(e,tp,eg,ep,ev,re,r,rp,0)==false then return end 
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end   
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end 
	end 
end