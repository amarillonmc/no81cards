--破碎溯时者
--21.04.10
local m=11451494
local cm=_G["c"..m]
function cm.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCondition(cm.redcon)
	e1:SetCost(cm.redcost)
	e1:SetOperation(cm.redop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
end
function cm.redcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0
end
function cm.redcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.redop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.regop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.getzone(p,loc,seq,tp)
	local zone=1<<seq
	if loc&LOCATION_SZONE~=0 then zone=zone<<8 end
	if p~=tp then zone=zone<<16 end
	if zone==0x20 or zone==0x400000 then zone=0x400020 end
	if zone==0x40 or zone==0x200000 then zone=0x200040 end
	return zone
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_ONFIELD==0 then return end
	local zone=cm.getzone(p,loc,seq,tp)
	local list={e:GetLabel()}
	table.insert(list,zone)
	e:SetLabel(table.unpack(list))
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_ONFIELD==0 then return false end
	local zone=cm.getzone(p,loc,seq,tp)
	local zone2=cm.getzone(p,loc,seq,1-tp)
	local list={e:GetLabelObject():GetLabel()}
	local t=0
	for i=1,#list do
		if zone==list[i] then t=t+1 end
	end
	if t~=1 and t~=2 then return false end
	e:SetLabel(zone,zone2,t)
	return true
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local zone,zone2,t=e:GetLabel()
	if t==1 then
		Duel.Hint(HINT_ZONE,tp,zone)
		Duel.Hint(HINT_ZONE,1-tp,zone2)
	elseif rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(rc,REASON_EFFECT)
	end
end