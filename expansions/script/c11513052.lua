--闪刀术式-银河跳跃
function c11513052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(c11513052.condition) 
	e1:SetTarget(c11513052.target) 
	e1:SetOperation(c11513052.operation) 
	c:RegisterEffect(e1) 
end
function c11513052.cfilter(c)
	return c:GetSequence()<5
end
function c11513052.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c11513052.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11513052.rmgck(g,tp) 
	local b1=g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,2,nil) 
	local b2=g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,2,nil) 
	local b3=g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,2,nil) 
	local b4=g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,2,nil) 
	local b5=g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,2,nil) 
	return b1 or b2 or b3 or b4 or b5  
end 
function c11513052.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,nil)   
	if chk==0 then return g:CheckSubGroup(c11513052.rmgck,1,1,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA) 
end 
function c11513052.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,nil) 
	local b1=g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,2,nil) 
	local b2=g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,2,nil) 
	local b3=g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,2,nil) 
	local b4=g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,2,nil) 
	local b5=g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,2,nil) 
	local sg=Group.CreateGroup() 
	if b1 then  
		sg:Merge(g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD))
	end 
	if b2 then  
		sg:AddCard(g:Filter(Card.IsLocation,nil,LOCATION_HAND):GetFirst())
	end 
	if b3 then  
		sg:Merge(g:Filter(Card.IsLocation,nil,LOCATION_GRAVE))
	end 
	if b4 then  
		sg:AddCard(g:Filter(Card.IsLocation,nil,LOCATION_DECK):GetFirst())
	end 
	if b5 then  
		sg:AddCard(g:Filter(Card.IsLocation,nil,LOCATION_EXTRA):GetFirst())
	end 
	if sg:GetCount()>0 then 
		local tc=sg:Select(tp,1,1,nil):GetFirst() 
		local loc=tc:GetLocation()
		if bit.band(loc,LOCATION_MZONE+LOCATION_SZONE)~=0 then loc=LOCATION_ONFIELD end 
		if tc:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA) then 
			local rdg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,loc,nil) 
			tc=rdg:RandomSelect(tp,1,REASON_EFFECT):GetFirst() 
		end  
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,loc,0,2,nil) then 

			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,loc,0,2,2,nil) 
			if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,3,nil,TYPE_SPELL) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(11513052,0)) then 
				Duel.SendtoHand(tc,tp,REASON_EFFECT) 
				Duel.ConfirmCards(1-tp,tc) 
			end 
		end 
	end 
end 














