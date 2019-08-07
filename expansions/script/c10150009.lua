--结界的消华
function c10150009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10150009.condition)
	e1:SetTarget(c10150009.target)
	e1:SetOperation(c10150009.activate)
	c:RegisterEffect(e1)   
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c10150009.handcon)
	c:RegisterEffect(e2) 
end
function c10150009.handcon(e)
	return Duel.IsExistingMatchingCard(c10150009.cfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c10150009.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:IsLevelAbove(8)
end
function c10150009.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_SYNCHRO) and re:GetHandler():IsControler(1-tp) and Duel.IsChainNegatable(ev)
end
function c10150009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
	   Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function c10150009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and Duel.GetControl(tc,tp) then
	if tc:IsRelateToEffect(re) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(c10150009.efilter)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2)
	end  
end
function c10150009.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

