local m=90700005
local cm=_G["c"..m]
cm.name="霜火铁卫"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.actcon)
	e1:SetOperation(cm.actop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	c90700005.act=e1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.immcon)
	e2:SetTarget(cm.immtarget)
	e2:SetValue(cm.immfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.actlimit)
	c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)>0 and not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.actfilter(c)
	return (not c:IsAttack(0) or not c:IsDefense(0)) and c:IsPosition(POS_FACEUP)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if e:GetLabel()==1 then
		tc=eg:GetFirst()
	else
		tc=e:GetHandler()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
	tc:RegisterEffect(e2)
	tc:AddCounter(0x5ac0,1)
	Duel.BreakEffect()
	local ffcount=Duel.GetCounter(tp,LOCATION_SZONE,0,0x5ac0)
	local field=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if field then
		ffcount=ffcount-field:GetCounter(0x5ac0)
	end
	if ffcount>=4 and Duel.IsExistingMatchingCard(cm.actfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(90700005,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			local actc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			actc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			actc:RegisterEffect(e2)
		end
	end
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x5ac0)>=6
end
function cm.immtarget(e,c)
	return c:GetCounter(0x5ac0)>0
end
function cm.immfilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.actlimit(e,re,tp)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x5ac0)>=12
end