--召魔亡语
function c99988021.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99988021+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99988021.target)
	e1:SetOperation(c99988021.activate)
	c:RegisterEffect(e1)
end
function c99988021.spfilter1(c,e,tp)
	return c:IsSetCard(0x20df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99988021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99988021.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99988021.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c99988021.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if not tc or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)<=0 or not tc:IsLocation(LOCATION_MZONE) or not tc:IsFaceup() then return end
	     local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	   if g1:GetCount()>0 and tc:GetOriginalRace()==RACE_FIEND then
	     Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 local tg=g1:Select(tp,1,1,e:GetHandler())
		 Duel.Destroy(tg,REASON_EFFECT)
	  end
	if not tc:GetOriginalRace()==RACE_ZOMBIE or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99988021.spfilter2),tp,LOCATION_GRAVE,0,nil,e,tp)
	if g2:GetCount()>0 then
		Duel.SpecialSummonStep(g2,0,tp,tp,false,false,POS_FACEUP) 
	end	
	if tc:GetOriginalRace()==RACE_FIEND or tc:GetOriginalRace()==RACE_ZOMBIE or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.SendtoGrave(tc,REASON_EFFECT)
	 end
function c99988021.spfilter2(c,e,tp)
	return not c:GetOriginalRace()==RACE_ZOMBIE and  c:IsSetCard(0x20df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
 end