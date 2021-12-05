local m=53799123
local cm=_G["c"..m]
cm.name="对立侧"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	if cm.counter==nil then
		cm.counter=true
		cm[0]=0
		cm[1]=0
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetOperation(cm.resetcount)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_CHAINING)
		e4:SetOperation(cm.checkop)
		Duel.RegisterEffect(e4,0)
	end
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	cm[rp]=cm[rp]+1
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.operation)
	Duel.RegisterEffect(e1,tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local ct=cm[1-tp]-4
	if ct<1 then return end
	Debug.Message("这个回合对方发动了"..cm[1-tp].."次效果，下回合「对立侧」可以适用"..ct.."次。")
	for i=1,ct do
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e4:SetCode(EVENT_CHAINING)
	--e4:SetReset(RESET_PHASE+PHASE_END,2)
	--e4:SetCondition(cm.con2)
	--e4:SetOperation(cm.chainop)
	--Duel.RegisterEffect(e4,tp)
	--Debug.Message(Duel.GetFlagEffect(tp,m))
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==tp and c:GetControler()==tp
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp) and Duel.GetFlagEffect(tp,m)>Duel.GetFlagEffect(tp,m+500)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.filter,nil,tp)
	local ct1=Duel.GetFlagEffect(tp,m)
	local ct2=Duel.GetFlagEffect(tp,m+500)
	if #g<1 or ct1<=ct2 then return end
	if #g==1 then
		if ct1>ct2 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.RegisterFlagEffect(tp,m+500,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(cm.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			g:GetFirst():RegisterEffect(e1)
			g:GetFirst():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		end
	else
		for tc in aux.Next(g) do
			if ct1>ct2 then
				Duel.Hint(HINT_CARD,0,tc:GetCode())
				if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
					Duel.RegisterFlagEffect(tp,m+500,RESET_PHASE+PHASE_END,0,1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCode(EFFECT_IMMUNE_EFFECT)
					e1:SetValue(cm.efilter)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
				end
			end
		end
	end
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
--function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	--return Duel.GetFlagEffect(tp,m)>Duel.GetFlagEffect(tp,m+500)
--end
--function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	--local ct1=Duel.GetFlagEffect(tp,m)
	--local ct2=Duel.GetFlagEffect(tp,m+500)
	--if ep==tp and ct1>ct2 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		--Duel.RegisterFlagEffect(tp,m+500,RESET_PHASE+PHASE_END,0,1)
		--Duel.SetChainLimit(cm.chainlm)
	--end
--end
--function cm.chainlm(e,rp,tp)
	--return tp==rp
--end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
