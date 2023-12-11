--本源玄力
function c9370000.initial_effect(c)
	aux.AddCodeList(c,9370000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9370000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9370000.target)
	e1:SetOperation(c9370000.activate)
	c:RegisterEffect(e1)
end
function c9370000.filter1(c,e,tp)
	return c:IsFaceup() and c:IsCanOverlay()
		and Duel.IsExistingMatchingCard(c9370000.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c9370000.filter2(c,e,tp,code)
	return c:IsCode(code) and c:IsType(TYPE_XYZ)
		and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0)
		or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
		or (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsFacedown()
			and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c9370000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9370000.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9370000.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9370000.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9370000.chainlm)
	end
end
function c9370000.chainlm(e,rp,tp)
	return e:GetHandler():IsCode(9370000)
end
function c9370000.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9370000.filter2),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode())
	local sc=g:GetFirst()
	if sc:IsLocation(LOCATION_EXTRA) and sc:IsFacedown() 
		and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or (sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(9370000,1)))) then
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local og=tc:GetOverlayGroup()
		if og:GetCount()~=0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		if c:IsRelateToEffect(e) and c:IsCanOverlay() 
		   and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanOverlay() and not tc:IsImmuneToEffect(e) then		   
				c:CancelToGrave()
				Duel.Overlay(sc,Group.FromCards(tc,c))
		elseif c:IsRelateToEffect(e) and c:IsCanOverlay()
		   and not (tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanOverlay() and not tc:IsImmuneToEffect(e)) then 
				Duel.Overlay(sc,Group.FromCards(c))
		elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanOverlay() and not tc:IsImmuneToEffect(e)
		   and not (c:IsRelateToEffect(e) and c:IsCanOverlay()) then 
				Duel.Overlay(sc,Group.FromCards(tc))
		end
	else
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local og=tc:GetOverlayGroup()
		if og:GetCount()~=0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		if c:IsRelateToEffect(e) and c:IsCanOverlay() 
		   and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanOverlay() and not tc:IsImmuneToEffect(e) then		   
				c:CancelToGrave()
				Duel.Overlay(sc,Group.FromCards(tc,c))
		elseif c:IsRelateToEffect(e) and c:IsCanOverlay()
		   and not (tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanOverlay() and not tc:IsImmuneToEffect(e)) then 
				Duel.Overlay(sc,Group.FromCards(c))
		elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanOverlay() and not tc:IsImmuneToEffect(e)
		   and not (c:IsRelateToEffect(e) and c:IsCanOverlay()) then 
				Duel.Overlay(sc,Group.FromCards(tc))
		end
	end
end