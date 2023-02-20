local m=53754005
local cm=_G["c"..m]
cm.name="异冽之社 被预言的终点"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.accon1)
	e2:SetOperation(cm.acop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.regcon)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.accon2)
	e4:SetOperation(cm.acop2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.acop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e6:SetCondition(cm.handcon)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.solving)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.solved)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.solving(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=true
end
function cm.solved(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=false
end
function cm.cfilter(c,tp)
	return not c:IsSummonableCard() and c:IsControler(1-tp)
end
function cm.accon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and not cm.chain_solving
end
function cm.acop1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsReason,1,nil,REASON_MATERIAL) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(cm.acop3)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(m)
		e5:SetTargetRange(1,0)
		e5:SetLabelObject(e1)
		Duel.RegisterEffect(e5,tp)
		local e6=e5:Clone()
		e6:SetLabelObject(e2)
		Duel.RegisterEffect(e6,tp)
		local e7=e5:Clone()
		e7:SetLabelObject(e3)
		Duel.RegisterEffect(e7,tp)
		local e8=e5:Clone()
		e8:SetLabelObject(e4)
		Duel.RegisterEffect(e8,tp)
	else cm.acop(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.acop3(e,tp,eg,ep,ev,re,r,rp)
	local le={Duel.IsPlayerAffectedByEffect(tp,m)}
	for _,v in pairs(le) do
		v:GetLabelObject():Reset()
		v:Reset()
	end
	cm.acop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and cm.chain_solving
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.accon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.acop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(m)
	e:GetHandler():ResetFlagEffect(m)
	for i=1,ct do cm.acop(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.ctfilter(c)
	return c:IsCanAddCounter(0x153d,1) and c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED+STATUS_LEAVE_CONFIRMED)
end
function cm.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_FLIP) and Duel.IsCanRemoveCounter(tp,1,1,0x153d,c:GetLevel()+1,REASON_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sfilter(c,lv,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(lv-1)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.GetTurnPlayer()~=tp and aux.bpcon() then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		g:GetFirst():AddCounter(0x153d,1)
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		local lvt={}
		for tc in aux.Next(g) do
			local tlv=tc:GetLevel()+1
			lvt[tlv]=tlv
		end
		local pc=1
		for i=1,13 do if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end end
		lvt[pc]=nil
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
		Duel.RemoveCounter(tp,1,1,0x153d,lv,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp):GetFirst()
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_IMMUNE_EFFECT)
			e0:SetValue(cm.efilter)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e0:SetOwnerPlayer(tp)
			sc:RegisterEffect(e0)
			Duel.SpecialSummonComplete()
			if sc:IsLocation(LOCATION_MZONE) then
			sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetTargetRange(0,LOCATION_MZONE)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e2:SetLabelObject(e1)
			e2:SetValue(function(e,c)return c==sc end)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_LEAVE_FIELD)
			e3:SetLabelObject(e2)
			e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:IsContains(sc)end)
			e3:SetOperation(cm.reset)
			Duel.RegisterEffect(e3,tp)
			end
		end
	elseif opval[op]==3 then
		local ac=Duel.GetAttacker()
		if ac and ac:IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.GetAttackTarget()==nil and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then Duel.NegateAttack() else
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_ATTACK_ANNOUNCE)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetCondition(cm.discon)
			e4:SetOperation(cm.disop)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetLabelObject():Reset()
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.GetAttackTarget()==nil
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,4)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateAttack()
	e:Reset()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
