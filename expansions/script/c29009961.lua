--怒号光明
function c29009961.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c29009961.condition)
	e1:SetTarget(c29009961.target)
	e1:SetOperation(c29009961.activate)
	c:RegisterEffect(e1)
end
--negate
function c29009961.stf(c) 
	local b1=c:IsSetCard(0x87af)
	local b2=(_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)
	return b1 or b2
end
function c29009961.nf(c) 
	return c:IsCode(29065500)
end
function c29009961.f(c) 
	return c:IsFaceup() and c29009961.stf(c) 
end
function c29009961.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29009961.f,tp,LOCATION_MZONE,0,nil)
	return #g>=2 and g:IsExists(c29009961.nf,1,nil) and Duel.IsChainNegatable(ev)
end
function c29009961.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c29009961.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
