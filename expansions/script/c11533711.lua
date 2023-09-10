--灾祸的灭炎
function c11533711.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetTarget(c11533711.actg) 
	e1:SetOperation(c11533711.acop) 
	c:RegisterEffect(e1)
end
function c11533711.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)>=4 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local x=0 
	if g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)>=6 then 
		x=Duel.AnnounceNumber(tp,4,6)  
	else 
		x=Duel.AnnounceNumber(tp,4)   
	end 
	local rg=g:RandomSelect(tp,x) 
	e:SetLabel(Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT))   
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)  
	local b=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA) 
	if b<=x and e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		Duel.SetChainLimit(c11533711.chlimit)
	end 
end
function c11533711.chlimit(e,ep,tp)
	return tp==ep
end
function c11533711.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c) 
	if x>0 and g:GetCount()>0 then 
		local xg=g:Select(tp,1,x,nil) 
		local tc=xg:GetFirst() 
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=xg:GetNext() 
		end   
	end 
end 





