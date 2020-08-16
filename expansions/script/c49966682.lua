--量子猫态
function c49966682.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c49966682.target)
	e1:SetOperation(c49966682.activate)
	c:RegisterEffect(e1)
end
function c49966682.afilter(c)
	return c:IsAbleToRemove()
end
function c49966682.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c49966682.afilter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c49966682.activate(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFieldCard(tp,LOCATION_DECK,0)
		if tc:IsAbleToRemove() 
		  and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	e1:SetCondition(c49966682.thcon)
	e1:SetOperation(c49966682.thop)
	e1:SetLabel(0)
	tc:RegisterEffect(e1)
end
end
function c49966682.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c49966682.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	 if ct==1 and e:GetHandler():IsType(TYPE_MONSTER) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
		Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)   
	else e:SetLabel(1)  
end
end