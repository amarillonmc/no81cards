--惊吓收缩
function c67210003.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67210003,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67210003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c67210003.condition)
	e1:SetTarget(c67210003.target)
	e1:SetOperation(c67210003.activate)
	c:RegisterEffect(e1) 
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c67210003.handcon)
	c:RegisterEffect(e2)   
end
function c67210003.filter(c,e,tp)
	return c:GetSummonPlayer()==1-tp and c:GetSequence()<=4
end
function c67210003.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67210003.filter,1,nil,nil,tp)
end
function c67210003.unfilter(c,e,tp)
	return c:GetSummonPlayer()==1-tp and not c:GetSequence()<=4
end
function c67210003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsExists(c67210003.unfilter,1,nil,nil,tp) end
end
function c67210003.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function c67210003.activate(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>0 then
		local tc=eg:GetFirst()
		while tc do
			local zone=1<<tc:GetSequence()
			local oc=Duel.GetMatchingGroup(c67210003.seqfilter,tp,0,LOCATION_SZONE,nil,tc:GetSequence()):GetFirst()
			if oc then
				Duel.Destroy(oc,REASON_RULE)
			end
			if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
			tc=eg:GetNext()
		end
	end
end
function c67210003.seqfilter(c,seq)
	return c:GetSequence()==seq
end
--
function c67210003.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
