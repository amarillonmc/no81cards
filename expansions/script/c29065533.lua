--方舟骑士升变
function c29065533.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,29065533+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29065533.target)
	e1:SetOperation(c29065533.activate)
	c:RegisterEffect(e1)
end
function c29065533.tgfilter(c,e,tp)
	return c:IsFaceupEx() and not c:IsCode(29065500)
		and Duel.IsExistingMatchingCard(c29065533.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,e,tp,c:GetCode())
end
function c29065533.thfilter(c,e,tp,code)
	return c:IsFaceupEx() and c:IsAbleToHand() and c:IsCode(29065500)
		and Duel.IsExistingMatchingCard(c29065533.fsfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,code,c)
end
function c29065533.fsfilter(c,e,tp,code,mc)
	return c:IsType(TYPE_FUSION) and c:IsCode(29065513,29012778) and aux.IsCodeListed(c,code)
		and c:CheckFusionMaterial() and aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_FMATERIAL)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c29065533.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c29065533.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c29065533.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c29065533.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29065533.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	if not tc:IsRelateToEffect(e) or not tc:IsFaceupEx() then return end
	local tg=Duel.GetMatchingGroup(c29065533.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tc,e,tp,tc:GetCode())
	if #tg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=tg:Select(tp,1,1,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c29065533.fsfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode(),sg:GetFirst())
		local sc=g:GetFirst()
		if sc then
			sc:SetMaterial(sg)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:CompleteProcedure()
			end
		end
	end
end
