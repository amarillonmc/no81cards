--折纸使-武魄融合
function c9910447.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCost(c9910447.cost)
	e1:SetTarget(c9910447.target)
	e1:SetOperation(c9910447.activate)
	e1:SetValue(c9910447.zones)
	c:RegisterEffect(e1)
end
function c9910447.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9910447.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
	local sg=Duel.GetMatchingGroup(c9910447.exfilter0,tp,LOCATION_EXTRA,0,nil)
	if Duel.IsExistingMatchingCard(c9910447.cfilter,tp,LOCATION_MZONE,0,1,nil) or sg:GetCount()==0
		or Duel.IsExistingMatchingCard(c9910447.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf) then
		return zone
	end
	mg1:Merge(sg)
	aux.FCheckAdditional=c9910447.fcheck(1)
	aux.GCheckAdditional=c9910447.gcheck(1)
	local res1=Duel.IsExistingMatchingCard(c9910447.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=c9910447.fcheck(2)
	aux.GCheckAdditional=c9910447.gcheck(2)
	local res2=Duel.IsExistingMatchingCard(c9910447.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if not res2 or (res1 and p0==p1) or (not res1 and not (p0 and p1)) then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c9910447.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsType(TYPE_PENDULUM))
end
function c9910447.filter1(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c9910447.exfilter0(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsCanBeFusionMaterial()
end
function c9910447.exfilter1(c,e)
	return c9910447.exfilter0(c) and not c:IsImmuneToEffect(e)
end
function c9910447.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3950) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9910447.fcheck(pt)
	return  function(tp,sg,fc)
				return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=pt
			end
end
function c9910447.gcheck(pt)
	return  function(sg)
				return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=pt
			end
end
function c9910447.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		if not Duel.IsExistingMatchingCard(c9910447.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local sg=Duel.GetMatchingGroup(c9910447.exfilter0,tp,LOCATION_EXTRA,0,nil)
			local pt=0
			if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pt=pt+1 end
			if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pt=pt+1 end
			if sg:GetCount()>0 and pt>0 then
				mg1:Merge(sg)
				aux.FCheckAdditional=c9910447.fcheck(pt)
				aux.GCheckAdditional=c9910447.gcheck(pt)
			end
		end
		local res=Duel.IsExistingMatchingCard(c9910447.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9910447.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910447.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9910447.filter1,nil,e)
	local exmat=false
	local pt=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pt=pt+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pt=pt+1 end
	if not Duel.IsExistingMatchingCard(c9910447.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(c9910447.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
		if sg:GetCount()>0 and pt>0 then
			mg1:Merge(sg)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=c9910447.fcheck(pt)
		aux.GCheckAdditional=c9910447.gcheck(pt)
	end
	local sg1=Duel.GetMatchingGroup(c9910447.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9910447.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c9910447.fcheck(pt)
				aux.GCheckAdditional=c9910447.gcheck(pt)
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			local pg=mat1:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			mat1:Sub(pg)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			for pc in aux.Next(pg) do
				Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9910447.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c9910447.splimit(e,c)
	return not c:IsSetCard(0x3950)
end
