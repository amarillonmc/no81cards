--升变之魔棋阵
function c51931006.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,51931006)
	e1:SetCost(c51931006.spcost)
	e1:SetTarget(c51931006.sptg)
	e1:SetOperation(c51931006.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51931007)
	e2:SetCost(c51931006.setcost)
	e2:SetTarget(c51931006.settg)
	e2:SetOperation(c51931006.setop)
	c:RegisterEffect(e2)
end
function c51931006.costfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToRemoveAsCost() and c:IsFaceupEx() and c:IsType(TYPE_MONSTER)
end
function c51931006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931006.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c51931006.costfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51931006.spfilter(c,e,tp)
	return c:IsSetCard(0x6258) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 and c:IsFaceupEx())
		or (Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0))
end
function c51931006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931006.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA)
end
function c51931006.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51931006.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c51931006.rmfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToRemoveAsCost()
end
function c51931006.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931006.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c51931006.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	sg:AddCard(e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51931006.setfilter(c,tp)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51931006.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c51931006.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c51931006.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c51931006.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
