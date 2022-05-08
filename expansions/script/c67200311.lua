--结天缘神 菲娅
function c67200311.initial_effect(c)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200311,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c67200311.pltg)
	e5:SetOperation(c67200311.plop)
	c:RegisterEffect(e5) 
end
function c67200311.plfilter(c)
	return c:IsSetCard(0x3671) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c67200311.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c67200311.plfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c67200311.plop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c67200311.plfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g2:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200311,1))
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
		e2:SetCondition(c67200311.spcon)
		e2:SetTarget(c67200311.sptg)
		e2:SetOperation(c67200311.spop)
		tc:RegisterEffect(e2)
	end
end
--
function c67200311.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsCode(67200311)
end
function c67200311.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200311.cfilter,1,nil,tp)
end
function c67200311.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200311.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
--