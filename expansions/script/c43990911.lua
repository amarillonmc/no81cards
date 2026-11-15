--诅咒与调伏之仪
function c43990911.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c43990911.condition)
	e1:SetTarget(c43990911.target)
	e1:SetOperation(c43990911.activate)
	c:RegisterEffect(e1)
end
function c43990911.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=3
end
function c43990911.spfilter(c,e,tp,chk)
	return c:IsCode(43990913) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_MONSTER)
end
function c43990911.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if chk==0 then return #sg>0 and Duel.GetLocationCountFromEx(tp,tp,sg,TYPE_LINK)>0
		and Duel.IsExistingMatchingCard(c43990911.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c43990911.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct==0 or Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c43990911.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		sc:AddCounter(0x514,ct)
	end
end
