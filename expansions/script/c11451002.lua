--白暮
local cm,m=GetID()
function cm.initial_effect(c)
	--hexperus
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(cm.cost)
	c:RegisterEffect(e0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.aclimit)
	local te=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	if te~=e then
		e1:SetTarget(cm.aclimit2)
		Duel.RegisterEffect(e1,tp)
		return
	end
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(cm.rsop)
	e2:SetLabelObject(e)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetOperation(cm.rsop2)
	e3:SetLabelObject(e)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function cm.aclimit(e,c)
	local te=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	return c:GetFlagEffect(m)>0 and c:GetFlagEffect(m-1)==0 and (not te or te~=e:GetLabelObject() or te:GetFieldID()~=e:GetLabelObject():GetFieldID())
end
function cm.aclimit2(e,c)
	return c:GetFlagEffect(m)>0
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	if rc:IsOnField() and (te==e:GetLabelObject() or re:IsHasType(EFFECT_TYPE_QUICK_F)) then rc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.rsop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	if rc:IsOnField() and (te==e:GetLabelObject() or re:IsHasType(EFFECT_TYPE_QUICK_F)) then rc:ResetFlagEffect(m-1) end
end