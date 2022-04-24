--幻星龙 星云烟尘
function c12057604.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c12057604.crcon)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c12057604.thcon)
	e2:SetTarget(c12057604.thtg)
	e2:SetOperation(c12057604.thop)
	c:RegisterEffect(e2)
end
function c12057604.crcon(e)
	 return Duel.GetCurrentPhase()~=PHASE_MAIN2 
end
function c12057604.thcon(e,tp,eg,ep,ev,re,r,rp) 
	 local c=e:GetHandler() 
	 return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end 
function c12057604.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end 
	 Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
end
function c12057604.thop(e,tp,eg,ep,ev,re,r,rp)  
	 local c=e:GetHandler()
	 local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	 if g:GetCount()>0 then 
	 local sg=g:Select(tp,1,1,nil)
	 Duel.SendtoHand(sg,tp,REASON_EFFECT)
	 end
end




