--战械死烬
function c29065608.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29065608+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29065608.target)
	e1:SetOperation(c29065608.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065608,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c29065608.sptg)
	e3:SetOperation(c29065608.spop)
	c:RegisterEffect(e3)
end
function c29065608.mttg(e,c)
	local tc=c:GetEquipTarget()
	return tc and tc:IsSetCard(0x87ad)
end
function c29065608.mtval(e,c)
	if not c then return false end
	return c:IsCode(29065607)
end
function c29065608.filter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c29065608.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c29065608.fcheck(tp,sg,fc)
	return true
end
function c29065608.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local me=Effect.CreateEffect(e:GetHandler())
		me:SetType(EFFECT_TYPE_FIELD)
		me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		me:SetTargetRange(LOCATION_SZONE,0)
		me:SetTarget(c29065608.mttg)
		me:SetValue(c29065608.mtval)
		Duel.RegisterEffect(me,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		Auxiliary.FCheckAdditional=c29065608.fcheck
		local res=Duel.IsExistingMatchingCard(c29065608.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c29065608.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		Auxiliary.FCheckAdditional=nil
		me:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29065608.activate(e,tp,eg,ep,ev,re,r,rp)
	local me=Effect.CreateEffect(e:GetHandler())
	me:SetType(EFFECT_TYPE_FIELD)
	me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	me:SetTargetRange(LOCATION_SZONE,0)
	me:SetTarget(c29065608.mttg)
	me:SetValue(c29065608.mtval)
	Duel.RegisterEffect(me,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c29065608.filter2,nil,e)
	Auxiliary.FCheckAdditional=c29065608.fcheck
	local sg1=Duel.GetMatchingGroup(c29065608.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c29065608.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	Auxiliary.FCheckAdditional=nil
	me:Reset()
end
function c29065608.spfilter(c,e,tp)
	return c:IsSetCard(0x87ad) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29065608.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29065608.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c29065608.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29065608.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end





