--人理之基 维纳莫宁
function c22023170.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023170,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22023170)
	e1:SetCondition(c22023170.spcon1)
	e1:SetTarget(c22023170.sptg1)
	e1:SetOperation(c22023170.spop1)
	c:RegisterEffect(e1)
	--public
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023170,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22023171)
	e2:SetOperation(c22023170.operation)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023170,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c22023170.discon)
	e3:SetTarget(c22023170.distg)
	e3:SetOperation(c22023170.disop)
	c:RegisterEffect(e3)
end
c22023170.effect_with_darkguda=true
function c22023170.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK 
end
function c22023170.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023170.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22023170.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023170.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22023170.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(22023170,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	Duel.RegisterFlagEffect(tp,22023171,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetCondition(c22023170.poscon)
	e2:SetTarget(c22023170.postg)
	e2:SetValue(POS_FACEUP_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(1000)
	Duel.RegisterEffect(e3,tp)
end
function c22023170.poscon(e)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(22023170)==e:GetLabel()
end
function c22023170.postg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x6ff1)
end
function c22023170.filter(c)
	return c:IsAttackPos()
end
function c22023170.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023171)>0
end
function c22023170.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023170.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22023170.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c22023170.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22023170.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
