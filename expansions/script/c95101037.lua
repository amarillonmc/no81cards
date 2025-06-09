--女仆维多利亚
function c95101037.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95101037)
	e1:SetCost(c95101037.spcost)
	e1:SetTarget(c95101037.sptg)
	e1:SetOperation(c95101037.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetDescription(aux.Stringid(95101037,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95101037+1)
	e2:SetCondition(c95101037.condition)
	--e2:SetCost(c95101037.cost)
	e2:SetTarget(c95101037.target)
	e2:SetOperation(c95101037.operation)
	c:RegisterEffect(e2)
end
function c95101037.costfilter(c,tp)
	return aux.IsCodeListed(c,95101001) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToHandAsCost()
end
function c95101037.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101037.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c95101037.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c95101037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101037.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95101037.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsMainPhase()--ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c95101037.filter2(c,e,tp,m,f,chkf,tc)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,tc,chkf)
end
function c95101037.exgfilter(c,mg,tc)
	return mg:CheckSubGroup(c95101037.exgselect,1,#mg,c,tc)
end
function c95101037.exgselect(g,xc,tc)
	return g:IsContains(tc) and xc:IsXyzSummonable(g,#g,#g)
end
function c95101037.tfilter(c,e,tp)
	if not c:IsCode(95101001) or c:IsFacedown() then return false end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local b1=Duel.IsExistingMatchingCard(c95101037.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,c)
	if not b1 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			b1=Duel.IsExistingMatchingCard(c95101037.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,c)
		end
	end
	local b2=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local b3=Duel.IsExistingMatchingCard(c95101037.exgfilter,tp,LOCATION_EXTRA,0,1,nil,mg,c)
	local b4=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,c)
	return b1 or b2 or b3 or b4
end
function c95101037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95101037.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c95101037.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c95101037.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c95101037.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c95101037.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c95101037.filter1,nil,e)
	local b1=Duel.IsExistingMatchingCard(c95101037.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,tc)
	if not b1 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			b1=Duel.IsExistingMatchingCard(c95101037.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,tc)
		end
	end
	local b2=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,tc) and tc:IsFaceup()
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local b3=Duel.IsExistingMatchingCard(c95101037.exgfilter,tp,LOCATION_EXTRA,0,1,nil,mg,tc) and tc:IsFaceup()
	local b4=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,tc) and tc:IsFaceup()
	if not (b1 or b2 or b3 or b4) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(95101037,1)},
		{b2,aux.Stringid(95101037,2)},
		{b3,aux.Stringid(95101037,3)},
		{b4,aux.Stringid(95101037,4)})
	if op==1 then
		local sg1=Duel.GetMatchingGroup(c95101037.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,tc)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c95101037.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,tc)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(sc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,sc,mg1,tc,chkf)
				sc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,sc,mg2,tc,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,sc,mat2)
			end
			sc:CompleteProcedure()
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,tc)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),tc)
		end
	elseif op==3 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(c95101037.exgfilter,tp,LOCATION_EXTRA,0,nil,mg,tc)
		if #exg==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=exg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local msg=mg:SelectSubGroup(tp,c95101037.exgselect,false,1,#mg,sc,tc)
		Duel.XyzSummon(tp,sc,msg,#msg,#msg)
	elseif op==4 then
		local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,tc)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,sg:GetFirst(),nil,tc)
		end
	end
end
