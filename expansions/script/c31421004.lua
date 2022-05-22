local m=31421004
local cm=_G["c"..m]
cm.name="弹幕少女『幻胧月睨』"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,cm.filter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.remcon)
	e2:SetCost(cm.remcost)
	e2:SetOperation(cm.remop)
	c:RegisterEffect(e2)
end
cm.list={31421001,31421002,31421003,31421004,31421005,31421006,31421007,31421008}
function cm.filter(c)
	return c:IsCode(table.unpack(cm.list))
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)
end
function cm.remcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(m)==0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local flag=(c:GetFlagEffect(m)~=0)
	if Duel.ReturnToField(c) and flag then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
function cm.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.efilter(e,re)
	return re==e:GetLabelObject()
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if chain==1 and Duel.GetCurrentPhase()==PHASE_END then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
	local chain=Duel.GetCurrentChain()
	if chain>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetValue(cm.efilter)
		e1:SetLabelObject(Duel.GetChainInfo(chain-1,CHAININFO_TRIGGERING_EFFECT))
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local tc=mg:Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DEFENSE_ATTACK)
		tc:RegisterEffect(e2)
	end
end