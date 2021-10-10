--空想融合
function c33310200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c33310200.target)
	e1:SetOperation(c33310200.activate)
	c:RegisterEffect(e1)
end
function c33310200.filter0(c)
	return c:IsPublic() and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsLocation(LOCATION_HAND)
end
function c33310200.filter1(c,e)
	return c:IsPublic() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToDeck()
end
function c33310200.filter2(c,e,tp,m,f,chkf,m2)
	if c:IsSetCard(0x551) then m:Merge(m2) end
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c33310200.filter3(c,e)
	return c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c33310200.grfilter(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c33310200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c33310200.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c33310200.filter0,tp,0,LOCATION_HAND,nil)
		mg1:Merge(mg2)
		local mg3=Duel.GetMatchingGroup(c33310200.grfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		local res=Duel.IsExistingMatchingCard(c33310200.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,mg3)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c33310200.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33310200.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c33310200.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(c33310200.filter1,tp,0,LOCATION_HAND,nil,e)
	mg1:Merge(mg2)
	local mg9=Duel.GetMatchingGroup(c33310200.grfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local sg1=Duel.GetMatchingGroup(c33310200.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,mg9)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c33310200.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsSetCard(0x551) then mg1:Merge(mg9) end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			local matg=mat1:Filter(Card.IsLocation,nil,LOCATION_DECK)
			local matc=matg:GetFirst()
			while matc do
				local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c33310200.distg)
		e1:SetLabelObject(matc)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c33310200.discon)
		e2:SetOperation(c33310200.disop)
		e2:SetLabelObject(matc)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
				matc=matg:GetNext()
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c33310200.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33310200.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33310200.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end