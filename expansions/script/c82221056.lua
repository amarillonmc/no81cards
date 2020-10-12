function c82221056.initial_effect(c)  
	--Activate 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetCost(c82221056.cost)  
	e1:SetOperation(c82221056.activate)  
	c:RegisterEffect(e1)  
end  
function c82221056.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0xf2) and c:IsAbleToRemoveAsCost()  
end   
function c82221056.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221056.cfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c82221056.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function c82221056.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)   
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e1:SetCode(EFFECT_DISABLE)  
	e1:SetTarget(c82221056.disable)
	e1:SetReset(RESET_PHASE+PHASE_END,1)  
	Duel.RegisterEffect(e1,tp) 
end
function c82221056.disable(e,c)  
	return not c:IsType(TYPE_PENDULUM)
end  