--噜噜噜
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetLabel(0)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetLabel(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))
	e1:SetCondition(s.condition)
	e1:SetOperation(s.spop)
	Duel.RegisterEffect(e1,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local last=e:GetLabel()
	local new=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	e:SetLabel(new)
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp)
	if new>last then
		for tc in aux.Next(g) do
			local val=aux.SequenceToGlobal(tc:GetControler(),LOCATION_MZONE,tc:GetSequence())
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetValue(val)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(s.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetOwnerPlayer(tp)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()==re:GetOwnerPlayer()
end