local m=82224060
local cm=_G["c"..m]
cm.name="扭曲融合"
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
function cm.confilter1(c)  
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end 
function cm.confilter2(c)  
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown()
end 
function cm.confilter3(c)  
	return c:IsLocation(LOCATION_HAND)
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetFusionMaterial(tp)  
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
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local chkf=tp  
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)  
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
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then  
		local sg=sg1:Clone()  
		if sg2 then sg:Merge(sg2) end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local tg=sg:Select(tp,1,1,nil)  
		local tc=tg:GetFirst()  
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then  
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1) 
			local mat11=mat1:Filter(cm.confilter1,nil)
			local mat12=mat1:Filter(cm.confilter2,nil)
			local mat13=mat1:Filter(cm.confilter3,nil)
			if mat11 then Duel.HintSelection(mat11) end
			if mat12 then Duel.ConfirmCards(1-tp,mat12) end
			if mat13 then Duel.ConfirmCards(1-tp,mat13) end
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:GetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e2)  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e3:SetCode(EVENT_PHASE+PHASE_END)  
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
		e3:SetCountLimit(1)  
		e3:SetLabelObject(tc)  
		e3:SetCondition(cm.descon)  
		e3:SetOperation(cm.desop)  
		Duel.RegisterEffect(e3,tp)  
		local e4=Effect.CreateEffect(c)  
		e4:SetType(EFFECT_TYPE_SINGLE)  
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e4:SetValue(0)  
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)  
		tc:RegisterEffect(e4)  
		local e5=e4:Clone()  
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)  
		tc:RegisterEffect(e5) 
	end  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	if tc:GetFlagEffectLabel(m)==e:GetLabel() then  
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