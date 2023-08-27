local m=82209178
local cm=c82209178
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_NEGATE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCategory(0)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.ac2)
	c:RegisterEffect(e2)
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x146) and c:IsType(TYPE_XYZ) 
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) 
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.cfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and re:GetHandler():IsCanOverlay() end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)  
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()
	local ec=re:GetHandler()  
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) and ec:IsCanOverlay() and (not ec:IsImmuneToEffect(e)) and tc:IsRelateToEffect(e) then  
		ec:CancelToGrave()  
		if ec:IsForbidden() then
			Duel.SendtoGrave(ec,REASON_RULE)
		else
			Duel.Overlay(tc,ec)
		end
	end  
end  
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetAttacker():IsControler(1-tp)  
end  
function cm.ovfilter(c,check,e)
	return c:IsPosition(POS_ATTACK) and c:IsCanOverlay() and not (check and c:IsImmuneToEffect(e))
end
function cm.cfilter2(c)  
	return c:IsFaceup() and c:IsSetCard(0x146) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) 
end  
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.cfilter2(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF) 
	local g=Duel.SelectTarget(tp,cm.cfilter2,tp,LOCATION_MZONE,0,1,1,nil) 
end  
function cm.check(c,tc)
	return tc:GetOverlayGroup():IsContains(c)
end
function cm.ac2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local og=Duel.GetMatchingGroup(cm.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,tc,1,e)
	Duel.Overlay(tc,og)
	if tc:IsFaceup() and og:FilterCount(cm.check,nil,tc)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)  
		e1:SetValue(tc:GetOverlayCount()*800)  
		tc:RegisterEffect(e1)  
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end