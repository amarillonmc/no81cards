--南瓜圣杯
function c77096006.initial_effect(c)
	aux.AddCodeList(c,77096005) 
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,77096006)
	e1:SetTarget(c77096006.actg)
	e1:SetOperation(c77096006.acop)
	c:RegisterEffect(e1)	
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,77096006) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c77096006.thtg)
	e2:SetOperation(c77096006.thop)
	c:RegisterEffect(e2)  
end
function c77096006.mfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() 
end
function c77096006.mfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c77096006.mfilter2(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c77096006.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c77096006.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCode(77096007) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c77096006.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp,LOCATION_MZONE)
		local res=Duel.IsExistingMatchingCard(c77096006.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		local mg2=Duel.GetMatchingGroup(c77096006.mfilter0,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
		mg2:Merge(mg1)
		res=Duel.IsExistingMatchingCard(c77096006.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c77096006.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77096006.acop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp,LOCATION_MZONE):Filter(c77096006.mfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c77096006.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=Duel.GetMatchingGroup(c77096006.mfilter2,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e)
	mg2:Merge(mg1)
	local sg2=Duel.GetMatchingGroup(c77096006.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
	sg1:Merge(sg2)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c77096006.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsCode(77096007) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				tc:SetMaterial(mat1) 
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) 
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function c77096006.thfil(c)
	return c:IsCode(77096005) and c:IsAbleToHand()
end
function c77096006.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c77096006.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c77096006.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c77096006.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end


