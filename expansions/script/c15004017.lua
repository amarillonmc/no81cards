local m=15004017
local cm=_G["c"..m]
cm.name="疫情防控"
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e1:SetCode(EVENT_MOVE)
	--e1:SetRange(LOCATION_SZONE)
	--e1:SetOperation(cm.dzop)
	--c:RegisterEffect(e1)
	--cannot
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.dzcon)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
end
function cm.dzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.valfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.valfilter(c)
	return c:GetSequence()<5
end
function cm.val(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.valfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local val=0
	local val0=0
	while tc do
		local x,zone=Duel.GetMZoneCount(tc:GetControler())
		local zoneall=0x1f001f
		local seq=tc:GetSequence()
		local seql=seq-1
		local seqr=seq+1
		if seq==0 then seql=5 end
		if seq==4 then seqr=5 end
-- and zone&aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seql)==0
		if seql<5 and val&aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seql)==0 then
			val=val+aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seql)
		end
		if seqr<5 and val&aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seqr)==0 then
			val=val+aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seqr)
		end
		tc=g:GetNext()
	end
	return val
end
function cm.dzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	while c:IsHasEffect(15004017) do
		Effect.Reset(c:IsHasEffect(15004017):GetLabelObject())
		Effect.Reset(c:IsHasEffect(15004017))
	end
	--if not Duel.IsExistingMatchingCard(cm.valfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then return end
	local g=Duel.GetMatchingGroup(cm.valfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local val=0
	while tc do
		local x,zone=Duel.GetMZoneCount(tc:GetControler())
		local zoneall=0x1f001f
		local seq=tc:GetSequence()
		local seql=seq-1
		local seqr=seq+1
		if seq==0 then seql=5 end
		if seq==4 then seqr=5 end
-- and zone&aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seql)==0
		if seql<5 and val&aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seql)==0 then
			val=val+aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seql)
		end
		if seqr<5 and val&aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seqr)==0 then
			val=val+aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,seqr)
		end
		tc=g:GetNext()
	end
	--cannot
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	--e1:SetCondition(cm.dzcon)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(15004017)
	e3:SetRange(LOCATION_SZONE) 
	e3:SetLabelObject(e1)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end