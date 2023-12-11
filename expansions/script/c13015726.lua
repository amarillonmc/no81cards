--深海姬蛊惑的歌声
function c13015726.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13015726,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,13015726)
	e1:SetCondition(c13015726.condition)
	e1:SetTarget(c13015726.target)
	e1:SetOperation(c13015726.activate)
	c:RegisterEffect(e1) 
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,23015726)
	e2:SetCondition(function(e) 
	return e:GetHandler():IsReason(REASON_EFFECT) end) 
	e2:SetCost(c13015726.setcost)
	e2:SetTarget(c13015726.settg)  
	e2:SetOperation(c13015726.setop)  
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e3) 
end
function c13015726.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe01) 
end
function c13015726.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c13015726.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return rp==1-tp 
end
function c13015726.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0) 
end
function c13015726.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(13015726,0)) then
		rc:CancelToGrave() 
		Duel.ChangePosition(rc,POS_FACEDOWN) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CANNOT_TRIGGER) 
		local reset=rc:IsControler(tp) and RESET_OPPO_TURN or RESET_SELF_TURN
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+reset) 
		rc:RegisterEffect(e1) 
	end
end 
function c13015726.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end 
function c13015726.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c13015726.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SSet(tp,c) 
	end 
end
