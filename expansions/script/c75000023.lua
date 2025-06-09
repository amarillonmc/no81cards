--纹章！结合！
function c75000023.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75000023+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75000023.target)
	e1:SetOperation(c75000023.activate)
	c:RegisterEffect(e1)
end
c75000023.fusion_effect=true
function c75000023.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c75000023.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsAbleToGrave()
end
function c75000023.filter(c)
	return c:IsAbleToGrave()
end
function c75000023.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,75000001) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.ttl_fusion_check or c75000023.frcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function c75000023.frcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionCode,1,nil,75000001)
end
function c75000023.fcheck(ct)
	return  function(tp,sg,fc)
				return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=ct
			end
end
function c75000023.gcheck(ct)
	return  function(sg)
				return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=ct
			end
end
function c75000023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c75000023.filter,nil)
		local mg2=Duel.GetMatchingGroup(c75000023.filter0,tp,LOCATION_DECK,0,nil)
		local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)+1


		if mg2:GetCount()>0 and mg1:GetCount()+ct>1 then
			mg1:Merge(mg2)
			aux.FCheckAdditional=c75000023.fcheck(ct)
			aux.GCheckAdditional=c75000023.gcheck(ct)
		end

		local res=Duel.IsExistingMatchingCard(c75000023.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c75000023.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75000023.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)+1
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c75000023.filter1,nil,e)
	local exmat=false
	local mg2=Duel.GetMatchingGroup(c75000023.filter0,tp,LOCATION_DECK,0,nil)
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
		exmat=true
	end
	if exmat then
			aux.FCheckAdditional=c75000023.fcheck(ct)
			aux.GCheckAdditional=c75000023.gcheck(ct)
	end
	local sg1=Duel.GetMatchingGroup(c75000023.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c75000023.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			aux.FCheckAdditional=c75000023.fcheck(ct)
			aux.GCheckAdditional=c75000023.gcheck(ct)
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
