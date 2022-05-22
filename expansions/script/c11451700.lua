--谈判
local m=11451700
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	local m1=m
	m1:RemoveCard(c)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m1,nil,chkf)
end
function cm.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and (c:IsAbleToRemove() or not c:IsLocation(LOCATION_GRAVE))
end
function cm.filter4(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetFusionMaterial(tp)
		local mg3=mg2+Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_GRAVE,0,nil)
		local mg4=mg3+Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_EXTRA,0,nil)
		local mg5=mg4+Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil)
		local flag1=(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
		local flag2=(flag1 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0)
		local flag3=(flag2 and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0)
		local flag4=(flag3 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==1)
		local flag5=(flag4 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0)
		local res1=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		local res2=flag1 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
		local res3=flag2 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,nil,chkf)
		local res4=flag3 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,nil,chkf)
		local res5=flag4 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg5,nil,chkf)
		local res6=flag5 and Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		Debug.Message(Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_EXTRA,0,1,nil,e,tp))
		local res=res1 or res2 or res3 or res4 or res5 or res6
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local mg2=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	local mg3=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_GRAVE,0,nil)
	local mg4=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_EXTRA,0,nil)
	local mg5=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil)
	local flag1=(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
	local flag2=(flag1 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0)
	local flag3=(flag2 and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0)
	local flag4=(flag3 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==1)
	local flag5=(flag4 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0)
	if flag1 then mg1:Merge(mg2) end
	if flag2 then mg1:Merge(mg3) end
	if flag3 then mg1:Merge(mg4) end
	if flag4 then mg1:Merge(mg5) end
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg6=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg6=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg6,mf,chkf)
	end
	local sg3=nil
	if flag5 then sg3=Duel.GetMatchingGroup(cm.filter4,tp,LOCATION_EXTRA,0,nil,e,tp) end
	if #sg1>0 or (sg2~=nil and #sg2>0) or (sg3~=nil and #sg3>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local s1=sg1:IsContains(tc)
		local s2=sg2 and sg2:IsContains(tc)
		local s3=sg3 and sg3:IsContains(tc)
		if s3 and ((not s1 and not s2) or Duel.SelectYesNo(tp,aux.Stringid(m,6))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tc:SetMaterial(nil)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)>0 then
				local WIN_REASON_NEGOTIATION=0x6b
				Duel.Win(tp,WIN_REASON_NEGOTIATION)
			end
		elseif s2 and (not s1 or Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg6,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		else
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			mat1:Sub(rg)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
end