--觉醒的三幻神
function c98500330.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	aux.AddCodeList(c,10000000,10000010,10000020)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,98500330)
	e1:SetCondition(c98500330.condition)
	e1:SetTarget(c98500330.target)
	e1:SetOperation(c98500330.activate)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500330,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98500331)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98500330.futg)
	e2:SetOperation(c98500330.fuop)
	c:RegisterEffect(e2)
end
function c98500330.cfilter(c)
	return c:IsFaceup() and c:IsCode(98500309,98500311)
end
function c98500330.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98500330.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98500330.spfilter(c,e,tp)
	return c:IsCode(10000000,10000010,10000020) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98500330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c98500330.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98500330.cfilter2(c)
	return c:IsFaceup() and c:IsCode(98500311)
end
function c98500330.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.GetMatchingGroup(c98500330.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.IsExistingMatchingCard(c98500330.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and sg:GetClassCount(Card.GetCode)>2 and Duel.SelectYesNo(tp,aux.Stringid(98500330,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=sg:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.SpecialSummon(sg2,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	--[[local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c98500330.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)]]--
		Duel.BreakEffect()
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98500330.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c98500330.splimit(e,c)
	return not c:IsRace(RACE_DIVINE)
end
function c98500330.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c98500330.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c98500330.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c98500330.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c98500330.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (c:IsRace(RACE_DIVINE) or c:IsAttribute(ATTRIBUTE_DIVINE)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c98500330.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c98500330.futg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c98500330.filter0,nil)
		if Duel.IsExistingMatchingCard(c98500330.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) then
			local mg2=Duel.GetMatchingGroup(c98500330.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
			mg1:Merge(mg2)
			aux.FCheckAdditional=c98500330.fcheck
			aux.GCheckAdditional=c98500330.gcheck
		else
			local mg2=Duel.GetMatchingGroup(c98500330.filter3,tp,LOCATION_GRAVE,0,nil)
			mg1:Merge(mg2)
		end
		local res=Duel.IsExistingMatchingCard(c98500330.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c98500330.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c98500330.fuop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c98500330.filter1,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(c98500330.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) then
		local mg2=Duel.GetMatchingGroup(c98500330.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		exmat=true
	else
		local mg2=Duel.GetMatchingGroup(c98500330.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
	end
	if exmat then
		aux.FCheckAdditional=c98500330.fcheck
		aux.GCheckAdditional=c98500330.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c98500330.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c98500330.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c98500330.fcheck
				aux.GCheckAdditional=c98500330.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
	end
end
