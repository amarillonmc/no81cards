--魔法使之箱
function c22024810.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024810,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22024810+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c22024810.cost)
	e1:SetTarget(c22024810.sptg)
	e1:SetOperation(c22024810.spop)
	c:RegisterEffect(e1)
end
function c22024810.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c22024810.filter0(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c22024810.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c22024810.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xff1) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c22024810.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22024811,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_LIGHT) and Duel.IsPlayerCanSpecialSummonMonster(tp,22024812,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c22024810.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22024811,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_LIGHT)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22024812,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,22024811)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local token2=Duel.CreateToken(tp,22024812)
	Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
	if Duel.SpecialSummonComplete() then
	--if (Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 or Duel.SpecialSummon(token2,0,tp,tp,false,false,POS_FACEUP)>0) then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c22024810.filter0,nil,e)
		local mg2=Duel.GetMatchingGroup(c22024810.filter1,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(mg2)
		local sg1=Duel.GetMatchingGroup(c22024810.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c22024810.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
		end
		if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(22024810,0)) then
			Duel.BreakEffect()
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end
