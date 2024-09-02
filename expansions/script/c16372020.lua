--花信物语 夏之契约
function c16372020.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16372020)
	e1:SetCondition(c16372020.setcon)
	e1:SetCost(c16372020.costoath)
	e1:SetTarget(c16372020.settg)
	e1:SetOperation(c16372020.setop)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16372020)
	e2:SetCost(c16372020.bfgcost)
	e2:SetTarget(c16372020.target2)
	e2:SetOperation(c16372020.activate2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(16372020,ACTIVITY_SPSUMMON,c16372020.counterfilter)
end
function c16372020.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372020.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372020,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372020.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372020.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372020.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.GetCustomActivityCount(16372020,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372020.splimitoath)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
c16372020.fusion_effect=true
function c16372020.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c16372020.tdfilter(c)
	return c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsAbleToDeck()
end
function c16372020.setfilter(c,tp)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c16372020.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c16372020.setfilter2(c,code)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and not c:IsCode(code)
end
function c16372020.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16372020.tdfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c16372020.tdfilter,tp,0,LOCATION_SZONE,1,nil)
		and Duel.IsExistingMatchingCard(c16372020.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_SZONE)
end
function c16372020.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c16372020.tdfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c16372020.tdfilter,tp,0,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	if #g1==2 and Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)==2
		and g1:GetFirst():IsLocation(LOCATION_DECK) and g1:GetNext():IsLocation(LOCATION_DECK) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16372020,0))
		local tc1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372020.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16372020,1))
		local tc2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372020.setfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc1:GetCode()):GetFirst()
		if tc1 and tc2 then
			Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc1:RegisterEffect(e1)
			Duel.MoveToField(tc2,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc2:RegisterEffect(e2)
		end
	end
end
function c16372020.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:GetOriginalType()&TYPE_MONSTER>0
end
function c16372020.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
		and c:GetOriginalType()&TYPE_MONSTER>0
end
function c16372020.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0xdc1)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c16372020.filter3(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c16372020.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetMatchingGroup(c16372020.filter0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c16372020.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c16372020.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c16372020.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c16372020.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(c16372020.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c16372020.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c16372020.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
end