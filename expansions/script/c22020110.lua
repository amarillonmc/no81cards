--人理之诗 转身火生三昧
function c22020110.initial_effect(c)
	aux.AddCodeList(c,22020010,22020120)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020110,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020110+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22020110.cost0)
	e1:SetTarget(c22020110.target)
	e1:SetOperation(c22020110.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020110,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c22020110.cost)
	e2:SetCountLimit(1,22020110+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c22020110.destg)
	e2:SetOperation(c22020110.desop)
	c:RegisterEffect(e2)
end
function c22020110.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020110,3))
end
function c22020110.filter(c)
	return c:IsFaceup() and c:IsAttackBelow(1800)
end
function c22020110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020110.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c22020110.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22020110,4))
end
function c22020110.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c22020110.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SelectOption(tp,aux.Stringid(22020110,5))
	Duel.Destroy(sg,REASON_EFFECT)
end
function c22020110.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22020110,7))
end
function c22020110.spfilter(c,e,tp)
	return c:IsCode(22020120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22020110.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22020110,8))
		Duel.Destroy(g,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22020110.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(22020110,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22020110.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(22020010) and Duel.GetMZoneCount(tp,c)>0
end
function c22020110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,c22020110.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,c22020110.cfilter,1,1,nil,tp)
	Duel.SelectOption(tp,aux.Stringid(22020110,6))
	Duel.Release(g,REASON_COST)
end