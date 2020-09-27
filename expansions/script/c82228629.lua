local m=82228629
local cm=_G["c"..m]
cm.name="孑影之终幕"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--act in set turn  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e2:SetCondition(cm.actcon)  
	c:RegisterEffect(e2)
end
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x3299)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsChainNegatable(ev)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return aux.nbcon(tp,re) end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)  
	end  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=re:GetHandler()  
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end  
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x3299)  
end  
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local g=Duel.GetFieldGroup(p,LOCATION_MZONE,0)  
	return #g>0 and g:FilterCount(cm.cfilter,nil)==#g  
end  