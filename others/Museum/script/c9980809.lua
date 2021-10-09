--Anything Goes!
function c9980809.initial_effect(c)
	c:SetUniqueOnField(1,0,9980809)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c9980809.sumsuc)
	c:RegisterEffect(e0)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e1:SetValue(c9980809.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,9980809)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c9980809.target)
	e1:SetOperation(c9980809.activate)
	c:RegisterEffect(e1)
end
function c9980809.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980809,0))
end 
function c9980809.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xabc1)
end
function c9980809.atkval(e,c)
	local g=Duel.GetMatchingGroup(c9980809.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)*200
end
function c9980809.filter1(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c9980809.exfilter0(c)
	return c:IsSetCard(0xabc1) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c9980809.exfilter1(c,e)
	return c:IsSetCard(0xabc1) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c9980809.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_WARRIOR) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9980809.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=2
end
function c9980809.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=2
end
function c9980809.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
			local sg=Duel.GetMatchingGroup(c9980809.exfilter0,tp,LOCATION_EXTRA,0,nil)
			if sg:GetCount()>0 then
				mg1:Merge(sg)
				Auxiliary.FCheckAdditional=c9980809.fcheck
				Auxiliary.GCheckAdditional=c9980809.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c9980809.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		Auxiliary.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9980809.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9980809.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9980809.filter1,nil,e)
	local exmat=false
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
		local sg=Duel.GetMatchingGroup(c9980809.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
		if sg:GetCount()>0 then
			mg1:Merge(sg)
			exmat=true
		end
	end
	if exmat then
		Auxiliary.FCheckAdditional=c9980809.fcheck
		Auxiliary.GCheckAdditional=c9980809.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c9980809.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9980809.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
				Auxiliary.FCheckAdditional=c9980809.fcheck
				Auxiliary.GCheckAdditional=c9980809.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
