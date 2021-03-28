--龙界咒 逆意志融合
function c99700285.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700285,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99700285+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c99700285.amcost)
	e1:SetTarget(c99700285.target)
	e1:SetOperation(c99700285.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700285,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99700285+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c99700285.amcost1)
	e2:SetTarget(c99700285.sptg)
	e2:SetOperation(c99700285.spop)
	c:RegisterEffect(e2)
end
function c99700285.filter0(c)
	return (c:IsFaceup() or c:IsFacedown()) and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c99700285.filter1(c,e)
	return (c:IsFaceup() or c:IsFacedown()) and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c99700285.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xfd04) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99700285.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c99700285.filter0,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
		local res=Duel.IsExistingMatchingCard(c99700285.filter2,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99700285.filter2,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE)
end
function c99700285.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c99700285.filter1,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c99700285.filter2,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99700285.filter2,tp,LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function c99700285.amcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.GetCustomActivityCount(99700285,tp,ACTIVITY_CHAIN+ACTIVITY_SUMMON+ACTIVITY_SPSUMMON+ACTIVITY_FLIPSUMMON+ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99700285.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c99700285.aclimit)
	Duel.RegisterEffect(e3,tp)
end
function c99700285.amcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99700285,tp,ACTIVITY_CHAIN+ACTIVITY_SUMMON+ACTIVITY_SPSUMMON+ACTIVITY_FLIPSUMMON+ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99700285.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c99700285.aclimit)
	Duel.RegisterEffect(e3,tp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99700285.splimit(e,c)
	return not (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd01) or c:IsSetCard(0xfd02) or c:IsSetCard(0xfd03) or c:IsSetCard(0xfd04))
end
function c99700285.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0xfd00) or re:GetHandler():IsSetCard(0xfd01) or re:GetHandler():IsSetCard(0xfd02) or re:GetHandler():IsSetCard(0xfd03) or re:GetHandler():IsSetCard(0xfd04))
end
function c99700285.fcheck(tp,sg,fc)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		return sg:IsExists(c99700285.filterchk,1,nil) end
	return true
end
function c99700285.filterchk(c)
	return (c:IsSetCard(0xfd04) or c:IsSetCard(0xfd00)) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and (c:IsFaceup() or c:IsFacedown())
end
function c99700285.filter01(c)
	return (c:IsFaceup() or c:IsFacedown()) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c99700285.filter11(c,e)
	return (c:IsFaceup() or c:IsFacedown()) and not c:IsImmuneToEffect(e)
end
function c99700285.filter21(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xfd04) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99700285.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c99700285.filter01,tp,LOCATION_DECK,0,nil)
		if mg:IsExists(c99700285.filterchk,1,nil) and mg2:GetCount()>0 then
			mg:Merge(mg2)
			aux.FCheckAdditional=c99700285.fcheck
		end
		local res=Duel.IsExistingMatchingCard(c99700285.filter21,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,mg,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99700285.filter21,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
end
function c99700285.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c99700285.filter11,nil,e)
	local mg2=Duel.GetMatchingGroup(c99700285.filter01,tp,LOCATION_DECK,0,nil)
	if mg1:IsExists(c99700285.filterchk,1,nil) and mg2:GetCount()>0 then
		mg1:Merge(mg2)
		aux.FCheckAdditional=c99700285.fcheck
	end
	local sg1=Duel.GetMatchingGroup(c99700285.filter21,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99700285.filter21,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,mg2,mf,chkf)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		aux.FCheckAdditional=c99700285.fcheck
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	else
		local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,mat2)
	end
	tc:CompleteProcedure()
end