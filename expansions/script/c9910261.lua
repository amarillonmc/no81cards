--幽鬼人偶 兰
function c9910261.initial_effect(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910261)
	e1:SetCost(c9910261.cost)
	e1:SetTarget(c9910261.target)
	e1:SetOperation(c9910261.operation)
	c:RegisterEffect(e1)
end
function c9910261.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	local fid=c:GetFieldID()
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910261.retcon)
		e1:SetOperation(c9910261.retop)
		Duel.RegisterEffect(e1,tp)
		c:RegisterFlagEffect(9910261,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
end
function c9910261.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffectLabel(9910261)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c9910261.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),tp,REASON_EFFECT)
end
function c9910261.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x953,3)
end
function c9910261.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910261.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910261.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910261.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x953)
end
function c9910261.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x953,3)
	end
end
