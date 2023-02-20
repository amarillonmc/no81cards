local m=53754004
local cm=_G["c"..m]
cm.name="异冽之堂 被曲解的意志"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.accon1)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(cm.accon2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_MOVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.regcon)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(cm.accon3)
	e6:SetOperation(cm.acop2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetOperation(cm.acop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e8:SetCondition(cm.handcon)
	c:RegisterEffect(e8)
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
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_SUMMON_COST)
		ge3:SetTargetRange(0xff,0xff)
		ge3:SetTarget(function(e,c,tp)
			e:SetLabelObject(c)
			return true 
		end)
		ge3:SetOperation(cm.summoncheck)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.solving(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=true
end
function cm.solved(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=false
end
function cm.summoncheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	c:RegisterFlagEffect(m,RESET_EVENT+0xff0000,0,0)
	if c:IsLocation(LOCATION_MZONE) then c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD,0,0) end
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsAttackAbove(1500) and c:GetFlagEffect(m+50)==0
end
function cm.cmovefilter(c,tp)
	return cm.cfilter(c,tp) and c:GetFlagEffect(m)==0 and not c:IsReason(REASON_SPSUMMON)
end
function cm.accon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cmovefilter,1,nil,tp) and not cm.chain_solving
end
function cm.accon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and not cm.chain_solving
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and cm.chain_solving
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.accon3(e,tp,eg,ep,ev,re,r,rp)
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
	if Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
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
		local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e4:SetTarget(function(e,c)return c:IsFacedown() and c==tc end)
		e4:SetValue(cm.efilter2)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_LEAVE_FIELD)
		e5:SetLabelObject(e4)
		e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:IsContains(tc)end)
		e5:SetOperation(cm.reset2)
		Duel.RegisterEffect(e5,tp)
	end
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():GetLabelObject():Reset()
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.reset2(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
