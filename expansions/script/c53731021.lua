local m=53731021
local cm=_G["c"..m]
cm.name="狂喑神影"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetLabelObject(e1)
		e2:SetValue(cm.aclimit)
		Duel.RegisterEffect(e2,tp)
		local op=aux.SelectFromOptions(tp,{true,aux.Stringid(m,1),3},{c:IsLevelAbove(2),aux.Stringid(m,2),-3},{true,aux.Stringid(m,3),0})
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(op)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EFFECT_SEND_REPLACE)
		e4:SetLabelObject(e1)
		e4:SetTarget(cm.reptarget)
		e4:SetOperation(cm.repoperation)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
	end
end
function cm.aclimit(e,re,tp)
	if not e:GetLabelObject() then
		e:Reset()
		return false
	end
	return re:GetHandler()==e:GetOwner() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetLabelObject() then
		e:Reset()
		return false
	end
	local c=e:GetHandler()
	if chk==0 then return c:IsPublic() and c:IsReason(REASON_RITUAL) and c:IsReason(REASON_RELEASE) and c:GetReasonCard():IsSetCard(0x9533) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:GetDestination()==LOCATION_GRAVE end
	return true
end
function cm.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
