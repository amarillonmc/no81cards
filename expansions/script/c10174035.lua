--测试
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174035)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"fus,sp")
	e1:RegisterSolve(nil,nil,cm.tg,cm.act)
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsOnField()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and m:CheckSubGroup(cm.matfilter,2,99,tp,c)
end
function cm.matfilter(g,tp,fusc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fusc)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
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
function cm.act(e,tp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local tc=nil
	local res,ct=0,0
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tc=sg:Select(tp,1,1,nil):GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=mg1:SelectSubGroup(tp,cm.matfilter,false,2,#mg1,tp,tc)
			res,ct=cm.material_check(tp,chkf,tc,mat1)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=mg2:SelectSubGroup(tp,cm.matfilter,false,2,#mg1,tp,tc)
			res,ct=cm.material_check(tp,chkf,tc,mat2)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end 
	if res~=0 then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop)
		Duel.RegisterEffect(e1,tp)
	end
	if res==2 then
		local e1,e2=rsef.SV_LIMIT({c,tc,true},"dis,dise",nil,nil,rsreset.est)
	end
	if ct>0 then
		local e1=rsef.SV_UPDATE({c,tc,true},"atk",2000*ct,nil,rsreset.est)
	end
end
function cm.fcheck(ct)
	return function(tp,sg,fc)
		if ct>2 then return #sg==ct
		else
			return #sg<=2
		end
	end
end
function cm.gcheck(ct)
	return function(sg)
		cm.fcheck(ct)(0,sg)
	end
end
function cm.fusfilter(mat,fusc,chkf)
	return fusc:CheckFusionMaterial(mat,nil,chkf)
end
function cm.fadd(ct)
	Auxiliary.FCheckAdditional=ct and cm.fcheck(ct) or nil
	Auxiliary.GCheckAdditional=ct and cm.gcheck(ct) or nil
end
function cm.material_check(tp,chkf,fusc,mat)
	if not fusc:CheckFusionMaterial(mat,nil,chkf) then return 2,0 end
	local res,ct=0,0
	cm.fadd(#mat)
	if not fusc:CheckFusionMaterial(mat,nil,chkf) then
		res=1
		for i=2,#mat-1 do
			cm.fadd(i) 
			if fusc:CheckFusionMaterial(mat,nil,chkf) then
				cm.fadd(i+1)
				if not fusc:CheckFusionMaterial(mat,nil,chkf) then
					ct=#mat-i
				end
			end
		end
	end
	cm.fadd(nil)
	return res,ct
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end