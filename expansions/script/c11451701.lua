--转生融合
local m=11451701
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.GetLocationCountFromEx(p,rp,g,sc,zone)
	return Duel.GetMZoneCount(p,g,rp,LOCATION_REASON_TOFIELD)
end
function cm.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true)) then return false end
	local _GetLocationCountFromEx=Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx=cm.GetLocationCountFromEx
	local res=c:CheckFusionMaterial(m,nil,chkf)
	Duel.GetLocationCountFromEx=_GetLocationCountFromEx
	return res
end
function cm.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_EXTRA,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_EXTRA,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local _GetLocationCountFromEx=Duel.GetLocationCountFromEx
			Duel.GetLocationCountFromEx=cm.GetLocationCountFromEx
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Duel.GetLocationCountFromEx=_GetLocationCountFromEx
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
		else
			local _GetLocationCountFromEx=Duel.GetLocationCountFromEx
			Duel.GetLocationCountFromEx=cm.GetLocationCountFromEx
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			Duel.GetLocationCountFromEx=_GetLocationCountFromEx
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end