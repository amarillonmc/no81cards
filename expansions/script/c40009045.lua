--机空援护 联合出击
function c40009045.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009045,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c40009045.sptarget)
	e2:SetOperation(c40009045.spoperation)
	c:RegisterEffect(e2)
end
function c40009045.spfilter1(c,e,tp)
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	return c:IsFaceup() and c:IsSetCard(0xf22) and c:IsType(TYPE_LINK) and zone>0 and Duel.IsExistingMatchingCard(c40009045.spfilter2,tp,LOCATION_EXTRA,0,1,c,e,tp,zone)
end
function c40009045.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0xf22) and c:IsType(TYPE_LINK) and c:IsLink(1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false,POS_FACEUP,tp,zone)
end
function c40009045.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c40009045.spfilter1(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c40009045.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40009045.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009045.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009045.spfilter2),tp,LOCATION_EXTRA,0,1,1,c,e,tp,zone)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,zone)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

