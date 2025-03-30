--人理异星 葛饰北斋
function c22021870.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2FunRep(c,22021850,22021860,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,3,true,true)
	--m-atk & atk-up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c22021870.mtcon)
	e1:SetOperation(c22021870.mtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c22021870.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--fusion (m)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021870,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22021870)
	e3:SetCondition(c22021870.condition)
	e3:SetTarget(c22021870.mftg)
	e3:SetOperation(c22021870.mfop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCondition(c22021870.condition1)
	c:RegisterEffect(e4)
	--fusion (m)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22021870,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22021870)
	e5:SetCondition(c22021870.erecon)
	e5:SetCost(c22021870.erecost)
	e5:SetTarget(c22021870.mftg)
	e5:SetOperation(c22021870.mfop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetCondition(c22021870.erecon1)
	c:RegisterEffect(e6)
end
function c22021870.valcheck(e,c)
	local ct1=c:GetMaterialCount()
	local ct2=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0xff1)
	e:GetLabelObject():SetLabel(ct1,ct2)
end
function c22021870.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c22021870.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1,ct2=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(ct1*1000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(ct2-1)
	c:RegisterEffect(e2)
end
function c22021870.condition(e)
	return not Duel.IsEnvironment(22702055)
end
function c22021870.condition1(e)
	return Duel.IsEnvironment(22702055)
end
function c22021870.mffilter0(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c22021870.mffilter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c22021870.mffilter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c22021870.mftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		mg1:Merge(Duel.GetMatchingGroup(c22021870.mffilter0,tp,0,LOCATION_MZONE,nil,e))
		local res=Duel.IsExistingMatchingCard(c22021870.mffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c22021870.mffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22021870.mfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c22021870.mffilter1,nil,e)
	mg1:Merge(Duel.GetMatchingGroup(c22021870.mffilter0,tp,0,LOCATION_MZONE,nil,e))
	local sg1=Duel.GetMatchingGroup(c22021870.mffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c22021870.mffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c22021870.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22021870.erecon(e)
	return not Duel.IsEnvironment(22702055) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22021870.erecon1(e)
	return Duel.IsEnvironment(22702055) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end