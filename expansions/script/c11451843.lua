--法术定序
--23.06.29
local cm,m=GetID()
function cm.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(cm.checkop3)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_LEAVE_FIELD_P)
		ge4:SetOperation(cm.checkop4)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:GetType()==TYPE_SPELL and rc:IsLocation(LOCATION_SZONE) then
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.checkop4(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(cm.cfilter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END-RESET_TOGRAVE-RESET_LEAVE,0,1)
	end
end
function cm.cfilter(c)
	return c:GetFlagEffect(m)>0 and c:IsLocation(LOCATION_SZONE) and c:GetDestination()==LOCATION_GRAVE
end
function cm.filter(c)
	return c:GetType()==TYPE_SPELL and not c:IsCode(m) and c:CheckActivateEffect(true,true,false)~=nil
end
function cm.filter2(c)
	return c:GetType()==TYPE_SPELL and not c:IsCode(m) and c:CheckActivateEffect(true,true,false)~=nil and c:GetFlagEffect(m-1)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	local fil=cm.filter
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then fil=cm.filter2 end
	if chk==0 then return Duel.IsExistingTarget(fil,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,fil,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local tc=te:GetHandler()
	if not (tc:IsRelateToEffect(e) and tc:GetType()==TYPE_SPELL) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end