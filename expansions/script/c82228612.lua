local m=82228612
local cm=_G["c"..m]
cm.name="荒兽 蛟"
function cm.initial_effect(c)
	--destroy  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))	
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMING_END_PHASE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
	--negate  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.discon)  
	e2:SetCost(cm.discost)  
	e2:SetTarget(cm.distg)  
	e2:SetOperation(cm.disop)  
	c:RegisterEffect(e2)  
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSetCard(0x2299)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end 
function cm.filter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsType(TYPE_FIELD) 
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return (chkc:IsOnField() or chkc:IsLocation(LOCATION_GRAVE)) and cm.filter(chkc) and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then
		if tc:IsLocation(LOCATION_GRAVE) and Duel.SSet(tp,tc,tp,true)~=0 then
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1) 
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)  
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e2) 
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e3:SetValue(LOCATION_REMOVED)  
			tc:RegisterEffect(e3,true) 
		else
			if tc:IsLocation(LOCATION_ONFIELD) and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)~=0 then
				local e1=Effect.CreateEffect(c)  
				e1:SetType(EFFECT_TYPE_SINGLE)  
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)  
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
				tc:RegisterEffect(e1) 
				local e2=Effect.CreateEffect(c)  
				e2:SetType(EFFECT_TYPE_SINGLE)  
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
				e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)  
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
				tc:RegisterEffect(e2) 
				local e3=Effect.CreateEffect(c)  
				e3:SetType(EFFECT_TYPE_SINGLE)  
				e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
				e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
				e3:SetValue(LOCATION_REMOVED)  
				tc:RegisterEffect(e3,true) 
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end  
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x2299) and c:IsType(TYPE_XYZ)  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)   
	return rp==1-tp and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateActivation(ev)  
end  