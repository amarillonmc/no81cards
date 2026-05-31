--死域海乱流
function c71280023.initial_effect(c)
	aux.AddCodeList(c,1127737)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71280023)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c71280023.condition)
	e1:SetTarget(c71280023.target)
	e1:SetOperation(c71280023.activate)
	c:RegisterEffect(e1)
end
function c71280023.filter(c)
	return c:IsCode(1127737)
end
function c71280023.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71280023.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c71280023.desfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c71280023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280023.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c71280023.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c71280023.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c71280023.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rk=Duel.Destroy(g,REASON_EFFECT)
	if rk~=0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c71280023.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,rk)
		and Duel.SelectYesNo(tp,aux.Stringid(71280023,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280023.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,rk):GetFirst()
		if sc then
			sc:SetMaterial(nil)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			--indes
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(c71280023.indval)
			sc:RegisterEffect(e2)
			sc:RegisterFlagEffect(71280023,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71280023,1))
			sc:CompleteProcedure()
			if c:IsRelateToEffect(e) then
				c:CancelToGrave()
				Duel.Overlay(sc,Group.FromCards(c))
			end
		end
	end
end
function c71280023.spfilter(c,e,tp,rk)
	return c:IsSetCard(0x48) and c:IsType(TYPE_XYZ) and c:IsRankBelow(rk)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c71280023.indval(e,c)
	return not c:IsSetCard(0x48)
end