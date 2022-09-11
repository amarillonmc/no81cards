--光彩夺目的DNA
local m=64800168
local cm=_G["c"..m]
function cm.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fcheck(tp,sg,fc)
	return sg:GetCount()<=Duel.GetLocationCount(tp,LOCATION_SZONE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE+LOCATION_HAND)
		Auxiliary.FCheckAdditional=cm.fcheck
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
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
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE+LOCATION_HAND)
	Auxiliary.FCheckAdditional=cm.fcheck
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,1))
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			for dc in aux.Next(mat1) do
				Duel.MoveToField(dc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
				dc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				dc:RegisterEffect(e1)
				dc:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			local seq=aux.GetColumn(tc)
			local table_copy = {}
			for ic in aux.Next(mat1) do
				table.insert(table_copy,ic)
				if seq == aux.GetColumn(ic,tp) then
					local code = ic:GetOriginalCodeRule()
					tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
				end
			end
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_BE_PRE_MATERIAL)
			e2:SetCondition(function(ce,ctp,ceg,cep,cev,cre,cr,crp) return cr & (REASON_XYZ | REASON_SYNCHRO | REASON_FUSION |REASON_LINK) ~= 0 end )
			e2:SetOperation(function(ce,ctp,ceg,cep,cev,cre,cr,crp)
								local rc = tc:GetReasonCard()
								local seq = tc:GetPreviousSequence()
								for _,v in ipairs(table_copy) do
									if aux.GetColumn(v) == seq and v:GetFlagEffect(m)>0 then
										local code1 = v:GetOriginalCodeRule()
										rc:CopyEffect(code1,RESET_EVENT+RESETS_STANDARD)
									end
									ce:Reset()
								end
							end)
			e2:SetReset(RESET_EVENT+RESET_TOFIELD)
			tc:RegisterEffect(e2)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	Auxiliary.FCheckAdditional=nil
end
