--人理之诗 逆行银河·赤方偏移
function c22023370.initial_effect(c)
	aux.AddCodeList(c,22023350,22023360)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023370+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(c22023370.cost)
	e1:SetTarget(c22023370.target)
	e1:SetOperation(c22023370.activate)
	c:RegisterEffect(e1)
end
function c22023370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,22023350) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,22023350)
	Duel.Release(g,REASON_COST)
end
function c22023370.filter(c,e,tp,att,mc)
	return c:IsCode(22023360) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c22023370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)
		and Duel.IsExistingMatchingCard(c22023370.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_CARD,0,22023350)
	Duel.SelectOption(tp,aux.Stringid(22023370,1))
	Duel.SelectOption(tp,aux.Stringid(22023370,2))
end
function c22023370.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) then return end
	local att=e:GetLabel()
	Duel.SelectOption(tp,aux.Stringid(22023370,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22023370.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SelectOption(tp,aux.Stringid(22023370,4))
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end
