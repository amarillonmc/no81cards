--超量变异
function c49920003.initial_effect(c)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c49920003.cost)
	e1:SetTarget(c49920003.target)
	e1:SetOperation(c49920003.activate)
	c:RegisterEffect(e1)
end
function c49920003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c49920003.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c49920003.filter2,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp,c)
end
function c49920003.filter2(c,rk,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsRank(rk) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c49920003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c49920003.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c49920003.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c49920003.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c49920003.filter2,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
end
