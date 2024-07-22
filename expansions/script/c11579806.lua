--额外承接使
function c11579806.initial_effect(c)
	c:SetSPSummonOnce(11579806)
	--link summon
	aux.AddLinkProcedure(c,function(c) return not c:IsSummonableCard() and not c:IsType(TYPE_LINK) end,1,1) 
	c:EnableReviveLimit()	
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetCountLimit(1,11579806)  
	e2:SetCost(c11579806.rmcost)
	e2:SetTarget(c11579806.rmtg) 
	e2:SetOperation(c11579806.rmop) 
	c:RegisterEffect(e2) 
end
function c11579806.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)  
end 
function c11579806.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil,POS_FACEDOWN) 
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_EXTRA) 
end 
function c11579806.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil,POS_FACEDOWN) 
	if g:GetCount()>=3 then 
		local rg=g:Select(tp,3,99,nil) 
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 then 
			local tc=rg:GetFirst() 
			while tc do 
			tc:RegisterFlagEffect(11579806,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
			tc=rg:GetNext() 
			end
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
			e1:SetCountLimit(1) 
			rg:KeepAlive()
			e1:SetLabelObject(rg)
			e1:SetCondition(function(e) 
			return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end) 
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			e:Reset() 
			local g=e:GetLabelObject() 
			local rg=g:Filter(function(c) return c:GetFlagEffect(11579806)~=0 end,nil) 
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT) 
			end )
			Duel.RegisterEffect(e1,tp)
		end  
	end 
end 




