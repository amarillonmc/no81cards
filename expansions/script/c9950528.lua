--交错进化
function c9950528.initial_effect(c)
 aux.AddCodeList(c,9950528)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c9950528.cost)
	e1:SetTarget(c9950528.target)
	e1:SetOperation(c9950528.activate)
	c:RegisterEffect(e1)
end
function c9950528.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9950528.filter1(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9950528.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c9950528.filter2(c,e,tp,tcode)
	return c:IsSetCard(0x9ba6) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950528.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c9950528.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c9950528.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c9950528.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9950528.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)>0 then
		tc:CompleteProcedure()
	end
end

