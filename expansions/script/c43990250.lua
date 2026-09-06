--蕾祸之野槌幼体
function c43990250.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43990250)
	e1:SetCondition(c43990250.spconSelf)
	e1:SetOperation(c43990250.spopSelf)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
 --   e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c43990250.target)
	e2:SetOperation(c43990250.activate)
	c:RegisterEffect(e2)

end

function c43990250.spcostfilter1(c)
	return c:IsSetCard(0x1ab)
end
function c43990250.spconSelf(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c43990250.spcostfilter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	return #g>0
end
function c43990250.spopSelf(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c43990250.spcostfilter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end

function c43990250.spfilter2(c,e,tp)
	return c:IsSetCard(0x1ab) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(43990250)
end
function c43990250.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43990250.spfilter2,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c43990250.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c43990250.spfilter2),tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end