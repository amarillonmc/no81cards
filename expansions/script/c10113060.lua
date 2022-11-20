--弹射起步
function c10113060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10113060.target)
	e1:SetOperation(c10113060.activate)
	c:RegisterEffect(e1)	
end
function c10113060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c10113060.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10113060.spfilter1(c,e,tp)
	return c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c10113060.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetRace())
end
function c10113060.spfilter2(c,e,tp,race)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsRace(race)
end
function c10113060.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10113060.spfilter1,tp,LOCATION_HAND,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or g:GetCount()<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=g:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=Duel.SelectMatchingCard(tp,c10113060.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,sg1:GetFirst():GetRace())
	sg1:Merge(sg2)
	local tc=sg1:GetFirst()
	while tc do
	   if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e1,true)
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_DISABLE_EFFECT)
		  e2:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e2,true)
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e3:SetRange(LOCATION_MZONE)
		  e3:SetCode(EVENT_PHASE+PHASE_END)
		  e3:SetCountLimit(1)
		  e3:SetOperation(c10113060.desop)
		  e3:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e3,true)
	   end
	 tc=sg1:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c10113060.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end