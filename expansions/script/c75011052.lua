--炼金工房的第二次夏天
function c75011052.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,75011052+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75011052.target)
	e1:SetOperation(c75011052.activate)
	c:RegisterEffect(e1)
end
function c75011052.tfilter(c,e,tp)
	return c:IsSetCard(0x75e) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c75011052.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function c75011052.spfilter(c,e,tp,attr)
	return not c:IsAttribute(attr) and c:IsSetCard(0x75e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75011052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75011052.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c75011052.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c75011052.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75011052.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75e) and c:IsLevelAbove(1)
end
function c75011052.tgfilter(c)
	return c:IsSetCard(0x75e) and c:IsAbleToGrave()
end
function c75011052.xfilter(c,e,tp,tc)
	return c:IsAttribute(tc:GetAttribute()) and c:IsSetCard(0x75e) and c:IsType(TYPE_XYZ) and tc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c75011052.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local attr=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c75011052.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,attr)
		if sg:GetCount()==0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
			and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
			and Duel.IsExistingMatchingCard(c75011052.xfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc)
			and Duel.SelectYesNo(tp,aux.Stringid(75011052,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c75011052.xfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
			if sc then
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(sc,Group.FromCards(tc))
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
			end
		end
	end
end
