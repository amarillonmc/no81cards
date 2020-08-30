function c82221058.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,82221058+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c82221058.target)  
	e1:SetOperation(c82221058.activate)  
	c:RegisterEffect(e1)  
end  
function c82221058.tgfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and (c:IsAbleToGrave() or c:IsAbleToExtra())  
end  
function c82221058.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221058.tgfilter,tp,LOCATION_DECK,0,1,nil) end  
end  
function c82221058.activate(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)  
	local g=Duel.SelectMatchingCard(tp,c82221058.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()  
	if g then
		if g:IsAbleToGrave() and g:IsAbleToExtra() then
			local ct=Duel.SelectOption(tp,aux.Stringid(82221058,0),aux.Stringid(82221058,1))
			if ct==0 then
				Duel.SendtoGrave(g,REASON_EFFECT) 
			else
				Duel.SendtoExtraP(g,nil,REASON_EFFECT) 
			end
		else
			if g:IsAbleToGrave() then
				Duel.SendtoGrave(g,REASON_EFFECT) 
			else
				if g:IsAbleToExtra() then
					Duel.SendtoExtraP(g,nil,REASON_EFFECT)
				else end
			end
		end
	end  
end  