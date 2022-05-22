--起舞的深海猎人
function c29010028.initial_effect(c)
	aux.AddCodeList(c,29010026,29010014,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29010028+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29010028.con)
	e1:SetTarget(c29010028.tg)
	e1:SetOperation(c29010028.act)
	c:RegisterEffect(e1)
end
function c29010028.con(e,tp,eg,ep,ev,re,r,rp)
   return Duel.IsEnvironment(22702055)
end
function c29010028.mfilter(c)
	return c:IsReleasable() and c:IsCode(29010014)
end
function c29010028.rfilter(c)
	return c:IsCode(29010026)
end
function c29010028.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and c29010028.mfilter(chkc) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<-1 then return false end
		local loc=LOCATION_HAND+LOCATION_MZONE
		if ft==0 then loc=LOCATION_MZONE end
	return Duel.IsExistingMatchingCard(c29010028.mfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c29010028.rfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c29010028.act(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	local loc=LOCATION_HAND+LOCATION_MZONE
	if ft==0 then loc=LOCATION_MZONE end
	local g1=Duel.SelectMatchingCard(tp,c29010028.mfilter,tp,loc,0,1,1,nil)
	if g1 then
		Duel.Release(g1,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29010028.rfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
	end
end
















