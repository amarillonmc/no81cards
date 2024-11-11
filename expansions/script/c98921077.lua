--双天之命魂-熊鹄
function c98921077.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c98921077.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x14f),true)	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921077,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98921077)
	e1:SetTarget(c98921077.target)
	e1:SetOperation(c98921077.operation)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,98922077)
	e2:SetCondition(c98921077.fcondition)
	e2:SetTarget(c98921077.ftarget)
	e2:SetOperation(c98921077.foperation)
	c:RegisterEffect(e2)
end
function c98921077.matfilter(c)
	return c:IsFusionSetCard(0x14f) and c:IsFusionType(TYPE_EFFECT)
end
function c98921077.dfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x14f) and Duel.GetMZoneCount(tp,c)>0
end
function c98921077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98921077.dfilter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return #g>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,87669905,0x14f,TYPES_TOKEN_MONSTER,0,0,2,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c98921077.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c98921077.dfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,87669905,0x14f,TYPES_TOKEN_MONSTER,0,0,2,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,87669905)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98921077.fcondition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c98921077.check(tp,g,fc)
	return g:IsExists(c98921077.fffilter,1,nil)
end
function c98921077.fffilter(c)
	return c:IsCode(87669905) or (c:IsType(TYPE_FUSION) and c:IsLevelAbove(5))
end
function c98921077.ftarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c98921077.filter0,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		aux.FCheckAdditional=c98921077.check
		local res=Duel.IsExistingMatchingCard(c98921077.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c98921077.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98921077.foperation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98921077.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	aux.FCheckAdditional=c98921077.check
	local sg1=Duel.GetMatchingGroup(c98921077.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c98921077.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			if mat:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			if mat:Filter(c98921077.cfilter,nil):GetCount()>0 then
				local cg=mat:Filter(c98921077.cfilter,nil)
				Duel.HintSelection(cg)
			end
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end
function c98921077.filter0(c)
	return c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c98921077.filter1(c,e)
	return c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c98921077.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x14f) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c98921077.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end