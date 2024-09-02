--花信物语 春之契约
function c16372019.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16372019)
	e1:SetCost(c16372019.costoath)
	e1:SetTarget(c16372019.target)
	e1:SetOperation(c16372019.activate)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16372019)
	e2:SetCost(c16372019.bfgcost)
	e2:SetTarget(c16372019.target2)
	e2:SetOperation(c16372019.activate2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(16372019,ACTIVITY_SPSUMMON,c16372019.counterfilter)
end
function c16372019.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372019.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372019,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372019.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372019.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372019.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.GetCustomActivityCount(16372019,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372019.splimitoath)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
c16372019.fusion_effect=true
function c16372019.ffilter(c,e,tp)
	return c:IsType(TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c16372019.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c,e,tp)
end
function c16372019.spfilter(c,fc,e,tp)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c16372019.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,fc,c:GetCode())
end
function c16372019.setfilter(c,fc,code)
	return aux.IsMaterialListCode(fc,c:GetCode()) and not c:IsForbidden() and not c:IsCode(code)
end
function c16372019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND) and 1 or 0
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>ft
		and Duel.IsExistingMatchingCard(c16372019.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c16372019.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c16372019.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c16372019.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc,e,tp):GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sc2=Duel.SelectMatchingCard(tp,c16372019.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc,sc:GetCode()):GetFirst()
			Duel.MoveToField(sc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			sc2:RegisterEffect(e1)
		end
	end
end
function c16372019.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:GetOriginalType()&TYPE_MONSTER>0
end
function c16372019.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
		and c:GetOriginalType()&TYPE_MONSTER>0
end
function c16372019.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0xdc1)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c16372019.filter3(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c16372019.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetMatchingGroup(c16372019.filter0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c16372019.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c16372019.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c16372019.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c16372019.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(c16372019.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c16372019.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c16372019.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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