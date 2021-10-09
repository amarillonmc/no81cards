--绝对异端的降临仪式
function c9950954.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950954+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9950954.target)
	e1:SetOperation(c9950954.activate)
	c:RegisterEffect(e1)
end
function c9950954.filter(c,e,tp)
	return c:IsSetCard(0x9ba7)
end
function c9950954.mfilter(c)
	return c:GetLevel()>0 and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToDeck()
end
function c9950954.cfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9950954.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local mg2=nil
		if Duel.IsExistingMatchingCard(c9950954.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			mg2=Duel.GetMatchingGroup(c9950954.mfilter,tp,LOCATION_GRAVE,0,nil)
		end
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c9950954.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
end
function c9950954.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local mg2=nil
	if Duel.IsExistingMatchingCard(c9950954.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		mg2=Duel.GetMatchingGroup(c9950954.mfilter,tp,LOCATION_GRAVE,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c9950954.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end