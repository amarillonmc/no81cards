--银河列车·瓦尔特
function c78311256.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,78311256)
	e1:SetCost(c78311256.cost)
	e1:SetTarget(c78311256.sptg)
	e1:SetOperation(c78311256.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x746))
	e2:SetValue(c78311256.batfilter)
	c:RegisterEffect(e2)
end
function c78311256.cfilter(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x746) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c78311256.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78311256.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c78311256.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c78311256.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c78311256.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c78311256.batfilter(e,c)
	local lv=e:GetHandler():GetLevel()
	local ct=0
	if c:IsType(TYPE_LINK) then
		ct=0
	elseif c:IsType(TYPE_XYZ) then
		if c:GetOriginalRank()<lv then ct=1 else ct=0 end
	else
		if c:GetOriginalLevel()<lv then ct=1 else ct=0 end
	end
	return ct
end
