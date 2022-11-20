--神龙之岚
function c10150001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10150001.cost)
	e1:SetCondition(c10150001.condition)
	e1:SetTarget(c10150001.target)
	e1:SetOperation(c10150001.activate)
	c:RegisterEffect(e1)	
end
function c10150001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10150001.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil)
end
function c10150001.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c10150001.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_EFFECT) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c10150001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10150001.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c10150001.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	local dg=Duel.GetMatchingGroup(c10150001.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c10150001.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10150001.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	local sg=Duel.GetMatchingGroup(c10150001.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and sg:GetCount()>0 then 
	  Duel.BreakEffect()
	  Duel.Destroy(sg,REASON_EFFECT)
	end
end