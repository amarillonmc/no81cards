--结天缘神 阳下誓约
function c67200315.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c67200315.condition)
	e1:SetTarget(c67200315.target)
	e1:SetOperation(c67200315.activate)
	c:RegisterEffect(e1)	
end
--
function c67200315.actfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c67200315.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c67200315.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200315.plfilter1(c)
	return c:IsCode(67200311,67200312) and not c:IsForbidden()
end
function c67200315.fselect(g)
	return g:GetClassCount(Card.GetCode)==2
end
function c67200315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c67200315.plfilter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and g:CheckSubGroup(c67200315.fselect,2,2) end
end
function c67200315.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c67200315.plfilter1,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local rg=g:SelectSubGroup(tp,c67200315.fselect,false,2,2)
	local tc=rg:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200315,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCondition(c67200315.spcon)
		e2:SetTarget(c67200315.sptg)
		e2:SetOperation(c67200315.spop)
		tc:RegisterEffect(e2)
		tc=rg:GetNext()
	end
end
--
function c67200315.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x671)
end
function c67200315.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200315.cfilter,1,nil,tp)
end
function c67200315.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200315.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
--

