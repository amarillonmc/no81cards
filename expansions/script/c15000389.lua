local m=15000389
local cm=_G["c"..m]
cm.name="黑潮再起"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,15000389)~=0 then
		Duel.ResetFlagEffect(tp,15000389)
		return
	end
	--set instead of send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCondition(cm.setcon)
	e2:SetOperation(cm.setop)
	e2:SetLabel(tp)
	Duel.RegisterEffect(e2,tp)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tp=e:GetLabel()
	return Duel.GetFlagEffect(tp,15000389)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
		and rc:GetType()==TYPE_SPELL and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and not rc:IsCode(15000389)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tp=e:GetLabel()
	rc:CancelToGrave()
	Duel.ChangePosition(rc,POS_FACEDOWN)
	Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	Duel.RegisterFlagEffect(tp,15000389,RESET_PHASE+PHASE_END,0,0)
end