--寒霜灵兽 白雾
function c33200917.initial_effect(c)
	c:SetUniqueOnField(1,0,33200917)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33200917.sttarget)
	c:RegisterEffect(e1)
	--spsm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200917,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c33200917.sptarget)
	e3:SetOperation(c33200917.spoperation)
	c:RegisterEffect(e3)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200917,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c33200917.condition)
	e2:SetTarget(c33200917.target)
	e2:SetOperation(c33200917.operation)
	c:RegisterEffect(e2)
end

--Activate
function c33200917.sttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c33200917.tdescon)
	e1:SetOperation(c33200917.tdesop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(33200917,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,5)
	c33200917[e:GetHandler()]=e1
end
function c33200917.tdescon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c33200917.tdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(m)
	end
end

--e3
function c33200917.filter(c,e,tp)
	return c:IsSetCard(0x332a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c33200917.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33200917.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33200917.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33200917.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)

  if g:GetCount()>0 then
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c33200917.descon)
		e2:SetOperation(c33200917.desop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
  end

end
function c33200917.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(33200917)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c33200917.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end

--e2
function c33200917.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function c33200917.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fc=Duel.GetFlagEffect(tp,33200917) 
	if fc>8 then fc=8 end
	local cc=10-fc
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,cc,REASON_EFFECT) and c:GetFlagEffect(33200917)==0 end
	c:RegisterFlagEffect(33200917,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c33200917.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fc=Duel.GetFlagEffect(tp,33200917) 
	if fc>8 then fc=8 end
	local cc=10-fc
	if Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,cc,REASON_EFFECT) then
		Duel.NegateActivation(ev)
	end
	Duel.RegisterFlagEffect(tp,33200917,nil,EFFECT_FLAG_OATH,1)
end