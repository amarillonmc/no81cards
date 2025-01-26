--判决牢狱的囚犯 09John
function c19209542.initial_effect(c)
	aux.AddCodeList(c,19209511,19209536)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c19209542.atkcon)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209542)
	e2:SetCondition(c19209542.descon)
	e2:SetTarget(c19209542.destg)
	e2:SetOperation(c19209542.desop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,19209543)
	e3:SetCondition(c19209542.spcon)
	e3:SetTarget(c19209542.sptg)
	e3:SetOperation(c19209542.spop)
	c:RegisterEffect(e3)
end
function c19209542.atkfilter(c)
	return c:IsCode(19209536) and c:IsFaceupEx()
end
function c19209542.atkcon(e)
	return Duel.IsExistingMatchingCard(c19209542.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
end
function c19209542.descon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(19209536)
end
function c19209542.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19209542.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c19209542.chkfilter(c)
	return c:IsCode(19209511) and c:IsFaceup()
end
function c19209542.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209542.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c19209542.spfilter(c,e,tp)
	return c:IsCode(19209536) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19209542.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c19209542.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE)) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209542.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
