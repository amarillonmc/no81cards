-- 穴墓的指名者
function c10200029.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10200029.target)
	e1:SetOperation(c10200029.activate)
	c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FilterBoolFunction(aux.NOT(Effect.IsActiveType),TYPE_TRAP))
end
function c10200029.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c10200029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and (chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_ONFIELD)) and c10200029.filter(chkc) end
	if chk==0 then
		local can_target_field=Duel.GetCustomActivityCount(10200029,1-tp,ACTIVITY_CHAIN)>0
		if can_target_field then return Duel.IsExistingTarget(c10200029.filter,tp,0,LOCATION_ONFIELD,1,nil)
		else return Duel.IsExistingTarget(c10200029.filter,tp,0,LOCATION_GRAVE,1,nil) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g
	if Duel.GetCustomActivityCount(10200029,1-tp,ACTIVITY_CHAIN)>0 then g=Duel.SelectTarget(tp,c10200029.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	else g=Duel.SelectTarget(tp,c10200029.filter,tp,0,LOCATION_GRAVE,1,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c10200029.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e1:SetTarget(c10200029.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c10200029.discon)
		e2:SetOperation(c10200029.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c10200029.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c10200029.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c10200029.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
