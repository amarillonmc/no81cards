--空の境界
function c60151299.initial_effect(c)
	c:SetUniqueOnField(1,0,60151299)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)  
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_ONFIELD,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_ONFIELD)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60151299,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c60151299.spcost)
	e5:SetTarget(c60151299.sptg)
	e5:SetOperation(c60151299.spop)
	c:RegisterEffect(e5)
end
function c60151299.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60151299.filter(c,e,tp,m1,m2)
	if not c:IsSetCard(0xab23) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c60151299.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and not c:IsType(TYPE_XYZ)
end
function c60151299.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c60151299.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		return Duel.IsExistingMatchingCard(c60151299.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60151299.afilter(c,tc)
	return c:GetRitualLevel(tc)<=tc:GetLevel() and c:IsCanBeRitualMaterial(tc) 
		and not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE) 
end
function c60151299.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c60151299.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c60151299.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local a=mg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
			if a:GetFirst():GetRitualLevel(tc)==tc:GetLevel() then
				tc:SetMaterial(a)
				Duel.ReleaseRitualMaterial(a)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
				tc:CompleteProcedure()
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,((tc:GetLevel())-(a:GetFirst():GetRitualLevel(tc))),1,99,tc)
				mat:Merge(a)
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
				tc:CompleteProcedure()
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end