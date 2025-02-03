--skip-飞世优马
function c36700102.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1152)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,36700102)
	e1:SetCondition(c36700102.spcon)
	e1:SetTarget(c36700102.sptg)
	e1:SetOperation(c36700102.spop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(TIMING_MAIN_END)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c36700102.seqcon)
	e2:SetTarget(c36700102.seqtg)
	e2:SetOperation(c36700102.seqop)
	c:RegisterEffect(e2)
end
function c36700102.chkfilter(c)
	return c:IsSetCard(0xc22) and c:IsFaceup()
end
function c36700102.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c36700102.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
		or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c36700102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c36700102.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c36700102.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c36700102.chfilter(c)
	return c:GetSequence()<5
end
function c36700102.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
		or Duel.IsExistingMatchingCard(c36700102.chfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c36700102.thfilter(c)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c36700102.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
	local b2=Duel.IsExistingMatchingCard(c36700102.chfilter,tp,LOCATION_MZONE,0,1,nil)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(36700102,0)},
		{b2,aux.Stringid(36700102,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		Duel.MoveSequence(c,seq)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,c36700102.chfilter,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SwapSequence(c,tc)
	end
	local s1=(c:GetSequence()==0 or c:GetSequence()==4) and Duel.IsExistingMatchingCard(c36700102.thfilter,tp,LOCATION_DECK,0,1,nil)
	local s2=c:GetSequence()==2 and Duel.IsPlayerCanDraw(tp,1)
	local s3=(c:GetSequence()==1 or c:GetSequence()==3) and c36700102.fsptg(e,tp,eg,ep,ev,re,r,rp,0)
	if s1 and Duel.SelectYesNo(tp,aux.Stringid(36700102,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c36700102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	elseif s2 and Duel.SelectYesNo(tp,aux.Stringid(36700102,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif s3 and Duel.SelectYesNo(tp,aux.Stringid(36700102,2)) then
		c36700102.fspop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c36700102.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c36700102.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c36700102.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsSetCard,1,nil,0xc22)
end
function c36700102.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		aux.FCheckAdditional=c36700102.fcheck
		local res=Duel.IsExistingMatchingCard(c36700102.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c36700102.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c36700102.fspop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c36700102.filter1,nil,e)
	aux.FCheckAdditional=c36700102.fcheck
	local sg1=Duel.GetMatchingGroup(c36700102.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c36700102.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			aux.FCheckAdditional=c36700102.fcheck
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
