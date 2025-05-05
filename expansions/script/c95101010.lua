--圣骑士贞妮德
function c95101010.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,95101010)
	e1:SetCost(c95101010.spcost)
	e1:SetTarget(c95101010.sptg)
	e1:SetOperation(c95101010.spop)
	c:RegisterEffect(e1)
	--spsummon-other
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101010,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,95101011)
	e2:SetTarget(c95101010.spotg)
	e2:SetOperation(c95101010.spoop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c95101010.costfilter(c,tp)
	return aux.IsCodeListed(c,95101001) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToHandAsCost()
end
function c95101010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101010.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c95101010.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c95101010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95101010.spfilter(c,e,tp)
	return aux.IsCodeListed(c,95101001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95101010.spotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c95101010.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c95101010.spoop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101010.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
