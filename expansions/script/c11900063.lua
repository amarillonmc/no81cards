--死者之王－奥西里斯
function c11900063.initial_effect(c)
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--to grave 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,11900063)
	e1:SetCost(c11900063.htgcost)
	e1:SetTarget(c11900063.htgtg) 
	e1:SetOperation(c11900063.htgop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,11910063)
	e2:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) end)
	e2:SetTarget(c11900063.thtg) 
	e2:SetOperation(c11900063.thop) 
	c:RegisterEffect(e2) 
end
function c11900063.htgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c11900063.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end 
function c11900063.htgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)  
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT)  
	end 
end 
function c11900063.thfil(c) 
	return c:IsAbleToHand() and (c:IsCode(11900061) or (aux.IsCodeListed(c,11900061) and c:IsType(TYPE_MONSTER)))   
end 
function c11900063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c11900063.thfil,tp,LOCATION_DECK,0,1,nil) end  
	if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c11900063.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11900063.thfil,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then 
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) then 
			Duel.BreakEffect() 
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil) 
			Duel.SendtoGrave(dg,REASON_EFFECT) 
			if c:IsRelateToEffect(e) and e:GetLabel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11900063,0)) then 
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
				Duel.Damage(1-tp,800,REASON_EFFECT) 
				local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
				if g:GetCount()<=0 then return end 
				local tc=g:GetFirst() 
				while tc do 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_UPDATE_ATTACK) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(-800) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
				tc:RegisterEffect(e1)   
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_UPDATE_DEFENSE) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(-800) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
				tc:RegisterEffect(e1)   
				tc=g:GetNext() 
				end 
			end 
		end  
	end 
end