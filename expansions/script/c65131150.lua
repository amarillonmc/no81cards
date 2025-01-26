--秘计螺旋 腐化
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTargetRange(1,1)
	e3:SetLabelObject(e2)
	e3:SetCost(s.costchk)
	e3:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
	--Trap activate in set turn
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetCost(s.qcost)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e6:SetTargetRange(LOCATION_ONFIELD,0)
	e6:SetTarget(s.stg)
	e6:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetCondition(s.leavecon)
	e7:SetOperation(s.leaveop)
	c:RegisterEffect(e7)
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function s.costchk(e,te_or_c,tp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,2,tc,POS_FACEDOWN)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,2,2,tc,POS_FACEDOWN)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	tc:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(s.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function s.qcost(e,tp,eg,ep,ev,re,r,rp,chk,ce)
	local codetable={}
	local code=ce:GetHandler():GetCode()
	local se=Duel.IsPlayerAffectedByEffect(tp,id)
	if se then codetable={se:GetLabel()} end
	if chk==0 then
		for _,v in pairs(codetable) do
			if v==code then
				return false
			end
		end
		return true
	end
	if se then
		table.insert(codetable,code)
		se:SetLabel(table.unpack(codetable))
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(id)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function s.stg(e,c)
	return c:GetOriginalType()&(TYPE_SPELL+TYPE_TRAP)>0 and not c:IsLocation(LOCATION_OVERLAY) and not c:IsType(TYPE_MONSTER)
end
function s.sfilter(c)
	return c:GetOriginalType()&(TYPE_SPELL+TYPE_TRAP)>0 and not c:IsLocation(LOCATION_OVERLAY) and not c:IsType(TYPE_MONSTER)
end
function s.leavecon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_REDIRECT==0 and eg:FilterCount(s.sfilter,nil)>0
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.sfilter,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REDIRECT)
	end
end