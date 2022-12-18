--九节棍史进君
function c22022470.initial_effect(c)
	aux.AddCodeList(c,22020850)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22022470)
	e1:SetTarget(c22022470.target)
	e1:SetOperation(c22022470.operation)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022470,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22022470)
	e2:SetTarget(c22022470.lvtg)
	e2:SetOperation(c22022470.lvop)
	c:RegisterEffect(e2)
end
function c22022470.filter1(c,e)
	return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)
end
function c22022470.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xff1) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22022470.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local res=Duel.IsExistingMatchingCard(c22022470.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c22022470.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22022470.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c22022470.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c22022470.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c22022470.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c22022470.lvfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(22022470)
end
function c22022470.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22022470.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22022470.lvfilter,tp,LOCATION_GRAVE,0,8,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22022470.lvfilter,tp,LOCATION_GRAVE,0,8,8,nil)
end
function c22022470.cfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c22022470.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c22022470.cfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(22020850)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end