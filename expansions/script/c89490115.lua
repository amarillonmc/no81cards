--天竺的鸣动
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490072)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target3)
	e1:SetOperation(s.activate3)
	c:RegisterEffect(e1)
end
function s.cfilter1(c)
	return c:IsCode(89490072) and c:IsFaceupEx()
end
function s.cfilter2(c)
	return c:IsSetCard(0xc36) and c:IsFaceupEx()
end
function s.remfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsControler(tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,5,nil) and re and rp~=tp and eg:IsExists(s.remfilter,1,nil,tp)
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0xc31) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.zfilter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.getzone(tp)
	local g=Duel.GetMatchingGroup(s.zfilter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for lc in aux.Next(g) do
		zone=zone|lc:GetLinkedZone()
	end
	return zone&0x1f
end
function s.spfilter2(c,e,tp,zone)
	return c:IsAttack(1500) and c:IsDefense(1100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=s.getzone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.fcheck2(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=s.getzone(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if zone==0 or ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>3 then ft=3 end
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,zone)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:SelectSubGroup(tp,s.fcheck2,false,1,ft)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function s.setfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xc37) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function s.fcheck3(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function s.activate3(e,tp,eg,ep,ev,re,r,rp)
	local n=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then n=n+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then n=n+1 end
	if n<=0 then return end
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=g:SelectSubGroup(tp,s.fcheck3,false,1,n)
	if #g1<=0 then return end
	local tc=g1:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		tc:SetStatus(STATUS_EFFECT_ENABLED,true)
		tc=g1:GetNext()
	end
end
