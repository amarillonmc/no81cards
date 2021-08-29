--钢战-世纪的颜色
function c82557942.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c82557942.target)
	e0:SetOperation(c82557942.operation)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c82557942.sptg)
	e2:SetOperation(c82557942.spop)
	c:RegisterEffect(e2)
end
function c82557942.filter(c,e,tp)
	return c:IsCode(82557951)
end
function c82557942.filter2(c)
	return  c:IsSetCard(0x829) and c:IsReleasable()
end
function c82557942.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return
   Duel.IsExistingMatchingCard(c82557942.filter,tp,LOCATION_HAND,0,1,nil)
	and  Duel.IsExistingMatchingCard(c82557942.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82557942.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82557942,1))
	local tg=Duel.SelectMatchingCard(tp,c82557942.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=Duel.SelectMatchingCard(tp,c82557942.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		end
end
function c82557942.spfilter(c,e,tp)
	return c:IsSetCard(0xa829) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82557942.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c82557942.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82557942.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c82557942.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if ft>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end