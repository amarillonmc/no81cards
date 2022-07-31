--破碎世界 黑色命运
function c6160602.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160602,0))  
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCountLimit(1,6160602)  
	e1:SetCondition(c6160602.condition)  
	e1:SetTarget(c6160602.target)  
	e1:SetOperation(c6160602.activate)  
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
	return c:IsFaceup() and c:IsSetCard(0x616) and c:IsType(TYPE_LINK)  
end
function c6160602.condition(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.IsExistingMatchingCard(c6160602.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end  
	if not Duel.IsChainNegatable(ev) then return false end  
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)  
end  
function c6160602.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function c6160602.activate(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  
function c6160602.recon(e)  
	return e:GetHandler():IsFaceup()  
end