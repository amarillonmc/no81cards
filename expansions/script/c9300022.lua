--反压
function c9300022.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9300022.thtg)
	e1:SetOperation(c9300022.thop)
	c:RegisterEffect(e1)
end
function c9300022.thfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
end
function c9300022.xfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and c:GetOverlayGroup():IsExists(c9300022.thfilter,1,nil,tp)
end
function c9300022.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9300022.xfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9300022.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9300022.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_OVERLAY)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9300022.chainlm)
	end
end
function c9300022.chainlm(e,lp,tp)
	local c=e:GetHandler()
	return tp==lp or not c:IsType(TYPE_XYZ)
end
function c9300022.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mg=tc:GetOverlayGroup():Filter(c9300022.thfilter,nil,tp)
	if tc:IsRelateToEffect(e) and #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local bc=mg:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoDeck(bc,nil,0,REASON_EFFECT)>0
			and bc:IsLocation(LOCATION_EXTRA) then
			if bc:GetOwner()==tp and tc:IsFaceup() and not tc:IsImmuneToEffect(e)
				and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and tc:IsCanBeXyzMaterial(bc)
				and bc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,bc)>0
				and Duel.SelectYesNo(tp,aux.Stringid(9300022,0)) then
				Duel.BreakEffect()
				local kg=tc:GetOverlayGroup()
				if kg:GetCount()~=0 then
					Duel.Overlay(bc,kg)
				end
				bc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(bc,Group.FromCards(tc))
				Duel.SpecialSummon(bc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				bc:CompleteProcedure()
			end
			if bc:GetOwner()==1-tp and tc:IsFaceup() and tc:IsRelateToEffect(e)
				and Duel.SelectYesNo(tp,aux.Stringid(9300022,1)) then
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end