--濑奈命
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,13)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	--e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--add effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.addcon)
	e3:SetOperation(s.addop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,e)
	return c:IsCode(id) and c:IsReleasable()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	Duel.Release(tc,REASON_COST)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	if Duel.GetCurrentPhase()==PHASE_BATTLE_START then
		e1:SetLabel(Duel.GetTurnCount()+1)
	else
		e1:SetLabel(Duel.GetTurnCount())
	end
	e1:SetCountLimit(1)
	e1:SetCondition(s.spccon)
	e1:SetOperation(s.spcop)
	Duel.RegisterEffect(e1,tp)
end
function s.spfilter(c,e,tp)
	return c:IsCode(id) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=e:GetLabel()
end
function s.spcop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		local sc=g:GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		local num=0
		for tc in aux.Next(g) do
			num=num+tc:GetFlagEffect(id)
		end
		e:Reset()
	end
end
function s.atkval(e,c)
	return c:GetOverlayCount()*100*math.max(1,c:GetFlagEffect(id))
end
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_REPLACE==0
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.max(1,c:GetFlagEffect(id))
	Duel.Destroy(c,REASON_REPLACE)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for i=1,ct do
		for tc in aux.Next(g) do				
			if tc:GetFlagEffect(id)==0 then
				tc:CopyEffect(id,RESET_EVENT+RESETS_STANDARD)
			end
			if tc:GetFlagEffect(id)<256 then
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			end
		end
	end
end