--始源的接触
function c10173018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10173018.target)
	e1:SetOperation(c10173018.activate)
	c:RegisterEffect(e1)
end
function c10173018.tgfilter(c,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c10173018.tgfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,c:GetAttribute()) and c:IsType(TYPE_MONSTER)
end
function c10173018.tgfilter2(c,att)
	return c:IsAbleToGrave() and not c:IsAttribute(att) and c:IsType(TYPE_MONSTER)
end
function c10173018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173018.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp) and Duel.IsExistingMatchingCard(c10173018.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_MZONE+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10173018.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c10173018.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10173018.tgfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,tc,tc:GetAttribute())
	g:AddCard(tc)
	if Duel.SendtoGrave(g,REASON_EFFECT)==2 and Duel.IsExistingMatchingCard(c10173018.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sc=Duel.SelectMatchingCard(tp,c10173018.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	   if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  sc:RegisterEffect(e1,true)
		  local e2=Effect.CreateEffect(c)
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_DISABLE_EFFECT)
		  e2:SetReset(RESET_EVENT+0x1fe0000)
		  sc:RegisterEffect(e2,true)
		  Duel.SpecialSummonComplete()
	  end
   end
end
