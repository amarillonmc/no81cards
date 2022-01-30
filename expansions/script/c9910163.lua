--战车道的旋律
function c9910163.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910163,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2,9910163)
	e2:SetTarget(c9910163.target)
	e2:SetOperation(c9910163.operation)
	c:RegisterEffect(e2)
end
function c9910163.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x952) and c:IsLevelAbove(1)
end
function c9910163.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910163.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910163.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9910163.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:IsLevel(1) then op=Duel.SelectOption(tp,aux.Stringid(9910163,1))
	else op=Duel.SelectOption(tp,aux.Stringid(9910163,1),aux.Stringid(9910163,2)) end
	e:SetLabel(op)
end
function c9910163.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if e:GetLabel()==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_BE_MATERIAL)
			e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
			e2:SetCondition(c9910163.imcon)
			e2:SetOperation(c9910163.imop1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e2)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-1)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_BE_MATERIAL)
			e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
			e2:SetCondition(c9910163.imcon)
			e2:SetOperation(c9910163.imop2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e2)
		end
	end
end
function c9910163.imcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ 
end
function c9910163.imop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(9910163,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9910163.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	rc:RegisterEffect(e1,true)
end
function c9910163.imop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(9910163,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	rc:RegisterEffect(e1,true)
end
function c9910163.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and re:IsActivated()
end
