--光影交织之刻
function c40009261.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009261,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c40009261.disrmcon)
	e1:SetTarget(c40009261.efftg)
	e1:SetOperation(c40009261.effop)
	c:RegisterEffect(e1)  
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009261,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,40009263)
	e2:SetTarget(c40009261.target)
	e2:SetOperation(c40009261.activate)
	c:RegisterEffect(e2)  
end
function c40009261.cfilter(c,code)
	return c:IsFaceup() and c:IsOriginalCodeRule(code)
end
function c40009261.cfilter1(c,e,tp)
	return c:IsCode(40009249)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c40009261.cfilter,tp,LOCATION_MZONE,0,1,nil,40009154)
end
function c40009261.cfilter2(c,e,tp)
	return c:IsCode(40009154) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c40009261.cfilter,tp,LOCATION_MZONE,0,1,nil,40009249)
end
function c40009261.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c40009261.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_WARRIOR) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c40009261.disrmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009261.cfilter,tp,LOCATION_MZONE,0,1,nil,40009154)
		or Duel.IsExistingMatchingCard(c40009261.cfilter,tp,LOCATION_MZONE,0,1,nil,40009249)
end
function c40009261.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
		local b1=Duel.IsExistingMatchingCard(c40009261.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,40009261)==0
		local b2=Duel.IsExistingMatchingCard(c40009261.cfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,40009262)==0
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40009261.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
		local b1=Duel.IsExistingMatchingCard(c40009261.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,40009261)==0
		local b2=Duel.IsExistingMatchingCard(c40009261.cfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,40009262)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(40009261,0),aux.Stringid(40009261,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(40009261,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(40009261,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c40009261.cfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,40009261,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c40009261.cfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,40009262,RESET_PHASE+PHASE_END,0,1)
	end
end
function c40009261.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c40009261.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c40009261.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009261.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c40009261.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c40009261.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c40009261.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end









