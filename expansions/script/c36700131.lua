--skip-伴博志
function c36700131.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,36700131+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c36700131.hspcon)
	e1:SetValue(c36700131.hspval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetDescription(1152)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,36700131)
	e2:SetCondition(c36700131.spcon)
	e2:SetCost(c36700131.spcost)
	e2:SetTarget(c36700131.sptg)
	e2:SetOperation(c36700131.spop)
	c:RegisterEffect(e2)
	--fusion
	local e3=Effect.CreateEffect(c)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetDescription(1169)
	e3:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,36700132)
	e3:SetCondition(c36700131.spcon)
	e3:SetTarget(c36700131.fstg)
	e3:SetOperation(c36700131.fsop)
	c:RegisterEffect(e3)
end
function c36700131.cfilter(c)
	return c:IsSetCard(0xc22) and c:IsFaceup()
end
function c36700131.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c36700131.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	return zone
end
function c36700131.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c36700131.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c36700131.hspval(e,c)
	local tp=c:GetControler()
	return 0,c36700131.getzone(tp)
end
function c36700131.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c36700131.costfilter(c)
	return c:IsCode(36700113) and c:IsAbleToGraveAsCost()
end
function c36700131.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36700131.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c36700131.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c36700131.spfilter(c,e,tp)
	return c:IsSetCard(0xc22) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c36700131.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c36700131.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c36700131.tgfilter(c,race,lv)
	return c:IsType(TYPE_MONSTER) and c:IsRace(race) and c:IsLevel(lv) and c:IsAbleToGrave()
end
function c36700131.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c36700131.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK)
	if sc and Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)~=0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(36700131,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		local race=Duel.AnnounceRace(tp,1,RACE_ALL)
		Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
		local lv=Duel.AnnounceLevel(tp)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(1-tp,c36700131.tgfilter,1,1,nil,race,lv)
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg:GetFirst():RegisterEffect(e1)
		end
	end
end
function c36700131.filter0(c,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c36700131.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c36700131.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc22) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c36700131.chkfilter(c)
	return c:IsCode(36700102,36700113) and c:IsFaceup()
end
function c36700131.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c36700131.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if Duel.IsExistingMatchingCard(c36700131.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local mg2=Duel.GetMatchingGroup(c36700131.filter0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
			mg1:Merge(mg2)
		end
		local res=Duel.IsExistingMatchingCard(c36700131.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c36700131.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c36700131.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c36700131.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if Duel.IsExistingMatchingCard(c36700131.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local mg2=Duel.GetMatchingGroup(c36700131.filter0,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		mg1:Merge(mg2)
	end
	local sg1=Duel.GetMatchingGroup(c36700131.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c36700131.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
end
