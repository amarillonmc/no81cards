--耍赖
--1200080
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0 and not Duel.CheckChainUniqueness()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	local id_tc_table={}
	local id_table={}
	for i=1,ev do
		local tid,tid2=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		if not id_tc_table[tid] then
			id_tc_table[tid]=Group.CreateGroup()
			id_table[tid]=0
		end
		if tid2~=0 and tid~=tid2 and not id_tc_table[tid2] then
			id_tc_table[tid2]=Group.CreateGroup()
			id_table[tid2]=0
		end
	end
	for i=1,ev do
		local tid,tid2,te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2,CHAININFO_TRIGGERING_EFFECT)
		id_tc_table[tid]:AddCard(te:GetHandler())
		id_table[tid]=id_table[tid]+1
		--Debug.Message('1')
		if tid2~=0 and tid~=tid2 then
			id_tc_table[tid2]:AddCard(te:GetHandler())
			id_table[tid2]=id_table[tid2]+1
		end
	end
	for v,tg in pairs(id_tc_table) do
		--Debug.Message(v)
		--Debug.Message(#tg)
		if id_table[v]>1 then
			local tc=tg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e1:SetTarget(s.distg)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(s.discon)
				e2:SetOperation(s.disop)
				e2:SetLabelObject(tc)
				e2:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
				tc=tg:GetNext()
			end
		end
	end
end
function s.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) 
		and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0))
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end