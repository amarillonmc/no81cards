--不知道
function c33591008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33591008+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c33591008.actg) 
	e1:SetOperation(c33591008.acop) 
	c:RegisterEffect(e1) 
end
function c33591008.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c33591008.chlimit) 
	end
end
function c33591008.chlimit(e,ep,tp)
	return not (e:GetHandler():IsOnField() and e:GetHandler():IsFacedown()) 
end
function c33591008.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc and tc:IsRelateToEffect(e) then 
		local code=Duel.AnnounceCard(tp) 
		Duel.ConfirmCards(tp,tc)
		if tc:IsCode(code) then 
			if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33591008,0)) then 
				local sc=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil):GetFirst() 
				local scode=Duel.AnnounceCard(tp) 
				Duel.ConfirmCards(tp,sc)
				if sc:IsCode(scode) then 
					Duel.Destroy(sc,REASON_EFFECT) 
				else
					Duel.PayLPCost(tp,1000)
				end  
			end 
		else 
			Duel.PayLPCost(tp,1000)
		end 
	end 
end













sNo(tp,aux.Stringid(33591008,0)) then 
    				local sc=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil):GetFirst() 
    				local scode=Duel.AnnounceCard(tp) 
    				Duel.ConfirmCards(tp,sc)
    				if sc:IsCode(scode) then 
    					Duel.Destroy(sc,REASON_EFFECT) 
    					local e1=Effect.CreateEffect(c)
            		    e1:SetType(EFFECT_TYPE_SINGLE)
            		    e1:SetCode(EFFECT_DISABLE)
            		    e1:SetReset(RESET_EVENT+0x17a0000)
            		    sc:RegisterEffect(e1)
            		    local e2=Effect.CreateEffect(c)
            		    e2:SetType(EFFECT_TYPE_SINGLE)
            		    e2:SetCode(EFFECT_DISABLE_EFFECT)
            		    e2:SetReset(RESET_EVENT+0x17a0000)
            		    sc:RegisterEffect(e2)
    				else
    					Duel.PayLPCost(tp,1000)
    				end  
    			end
    	    end 
		else 
			Duel.PayLPCost(tp,1000)
		end 
	end 
end













