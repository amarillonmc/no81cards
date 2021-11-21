--云魔物-砧状云
function c99913710.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	e1:SetCondition(c99913710.hspcon)
	e1:SetOperation(c99913710.hspop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99913710,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c99913710.condition)
	e2:SetTarget(c99913710.sptg)
	e2:SetOperation(c99913710.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99913710.effectfilter)
	c:RegisterEffect(e3)
end
function c99913710.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x18)
end
function c99913710.rfilter(c)
	return c:GetCounter(0x1019)>0 and c:IsAbleToGraveAsCost()
end
function c99913710.rfilter2(c)
	return c:GetCounter(0x1019)>0
end
function c99913710.hspcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local m=0
	if ft<=0 then return false end
	--if ft>0 then m=LOCATION_MZONE end
	--return ft>-1 and Duel.IsExistingMatchingCard(c99913710.rfilter,tp,LOCATION_MZONE,m,1,nil)
	return ft>0 and (Duel.IsExistingMatchingCard(c99913710.rfilter,tp,0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(c99913710.rfilter2,tp,LOCATION_MZONE,0,1,nil))
end
function c99913710.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local m=0
	--if ft>0 then m=LOCATION_MZONE end
	if ft<=0 then return false end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	--local g=Duel.SelectMatchingCard(tp,c99913710.rfilter,tp,LOCATION_MZONE,m,1,1,nil)
	local g=Duel.GetMatchingGroup(c99913710.rfilter2,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c99913710.rfilter,tp,0,LOCATION_MZONE,nil)
	g:Merge(g2)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:GetControler()==tp then
		tc:RemoveCounter(tp,0x1019,tc:GetCounter(0x1019),REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_COST)
	end
end
function c99913710.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c99913710.spfilter(c,e,tp)
	return c:IsCode(80825553) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99913710.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99913710.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c99913710.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99913710.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
