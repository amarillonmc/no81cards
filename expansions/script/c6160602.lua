--破碎世界 黑色命运
function c6160602.initial_effect(c)
	--Activate(effect)  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCondition(c6160602.condition2)	  
	e1:SetTarget(c6160602.target2)  
	e1:SetOperation(c6160602.activate2)  
	c:RegisterEffect(e1)  
	--redirect  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetCondition(c6160602.recon)  
	e2:SetValue(LOCATION_REMOVED)  
	c:RegisterEffect(e2)  
end 
function c6160602.cfilter(c)  
	return c:IsFaceup() and c:IsLevelAbove(8) and c:IsSetCard(0x616)   
end
function c6160602.condition2(e,tp,eg,ep,ev,re,r,rp)  
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)  
		and not Duel.IsExistingMatchingCard(c6160602.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())  
end  
function c6160602.target2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function c6160602.activate2(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  
function c6160602.recon(e)  
	return e:GetHandler():IsFaceup()  
end