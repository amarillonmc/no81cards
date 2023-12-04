--摆设融合
function c9300020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9300020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,9300020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9300020.condition)
	e1:SetTarget(c9300020.target)
	e1:SetOperation(c9300020.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9300020,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9301020)
	e2:SetCost(c9300020.thcost)
	e2:SetTarget(c9300020.thtg)
	e2:SetOperation(c9300020.thop)
	c:RegisterEffect(e2)
end
function c9300020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==0
		   and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function c9300020.filter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
			and c:IsCanBeFusionMaterial() and not c:IsForbidden()
end
function c9300020.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_PENDULUM) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9300020.filter3(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
			and c:IsCanBeFusionMaterial() and not c:IsForbidden()
end
function c9300020.fcheck(tp,sg,fc)
	return #sg<=2
end
function c9300020.gcheck(sg)
	return #sg<=2
end
function c9300020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c9300020.filter1,tp,LOCATION_EXTRA,0,nil)
		aux.FCheckAdditional=c9300020.fcheck
		aux.GCheckAdditional=c9300020.gcheck
		local res=Duel.IsExistingMatchingCard(c9300020.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):Filter(c9300020.filter3,nil)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9300020.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		return res and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9300020.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_PZONE)>0 then return end
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c9300020.filter1,tp,LOCATION_EXTRA,0,nil)
	aux.FCheckAdditional=c9300020.fcheck
	aux.GCheckAdditional=c9300020.gcheck
	local sg1=Duel.GetMatchingGroup(c9300020.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(c9300020.filter3,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9300020.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) 
			and Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
			and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local lc=mat1:GetFirst()
			local rc=mat1:GetNext()
			Duel.MoveToField(lc,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			lc:SetStatus(STATUS_EFFECT_ENABLED,true)
			Duel.MoveToField(rc,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
end
function c9300020.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function c9300020.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9300020.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9300020.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9300020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9300020.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end