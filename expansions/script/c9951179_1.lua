--伊丽莎白演唱会仪式
function c9951179.initial_effect(c)
	 --Activate
	local e1=aux.AddRitualProcEqual2(c,c9951179.ffilter1,LOCATION_GRAVE+LOCATION_HAND,c9951179.ffilter2)
  --fusion summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951179,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9951179)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9951179.sptg)
	e3:SetOperation(c9951179.spop)
	c:RegisterEffect(e3)
end
function c9951179.ffilter1(c)
	return c:IsSetCard(0x9ba8)
end
function c9951179.ffilter2(c)
	return c:IsSetCard(0xba5)
end
function c9951179.spfilter1(c,e)
	return c:IsSetCard(0x9ba8) and not c:IsImmuneToEffect(e)
end
function c9951179.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9951179.spfilter3(c)
	return c:IsCanBeFusionMaterial() and c:IsSetCard(0x10f3)
end
function c9951179.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsSetCard,nil,0x10f3)
		local res=Duel.IsExistingMatchingCard(c9951179.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):Filter(c9951179.spfilter3,nil)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9951179.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9951179.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9951179.spfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c9951179.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(c9951179.spfilter3,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9951179.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
