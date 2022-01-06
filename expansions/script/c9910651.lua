--无界星结
function c9910651.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910651.target)
	e1:SetOperation(c9910651.activate)
	c:RegisterEffect(e1)
end
function c9910651.cfilter(c,rk,e)
	return c:IsLevelBelow(rk) and c:IsFaceup() and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c9910651.filter1(c,e,tp)
	local rk=c:GetRank()
	local ra=c:GetRace()
	local att=c:GetAttribute()
	local sg=Duel.GetMatchingGroup(c9910651.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,rk)
	return rk>0 and c:IsFaceup() and c:GetOverlayCount()<=2 and sg:GetCount()>0
		and Duel.IsExistingMatchingCard(c9910651.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk,ra,att,sg)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9910651.filter2(c,e,tp,mc,rk,ra,att,mg)
	return c:IsRank(rk) and c:IsRace(ra) and c:IsAttribute(att) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and (Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 or Duel.GetLocationCountFromEx(tp,tp,mg,c)>0)
end
function c9910651.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910651.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910651.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910651.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910651.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local rk=tc:GetRank()
	local ra=tc:GetRace()
	local att=tc:GetAttribute()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c9910651.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,tc,rk,e)
	if sg:GetCount()==0 then return end
	local og=Group.CreateGroup()
	for sc in aux.Next(sg) do
		og:Merge(sc:GetOverlayGroup())
	end
	if og:GetCount()>0 then
		Duel.SendtoGrave(og,REASON_RULE)
	end
	Duel.Overlay(tc,sg)
	if tc:IsControler(1-tp) or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910651.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rk,ra,att)
	local xc=g:GetFirst()
	if xc then
		Duel.BreakEffect()
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(xc,mg)
		end
		xc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(xc,Group.FromCards(tc))
		Duel.SpecialSummonStep(xc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		xc:RegisterEffect(e1,true)
		xc:CompleteProcedure()
	end
end
