--渴血嚣狂的恋慕屋敷
function c9911087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,9911087+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9911087.condition)
	e1:SetTarget(c9911087.target)
	e1:SetOperation(c9911087.activate)
	c:RegisterEffect(e1)
end
function c9911087.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9911087.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c9911087.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c9911087.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9954) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9911087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local mg2=Duel.GetMatchingGroup(c9911087.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c9911087.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9911087.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911087.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,1)
end
function c9911087.activate(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9911087.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c9911087.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c9911087.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local spchk=0
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9911087.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			spchk=1
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			spchk=1
		end
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(9911087,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(9911087,1))
		g:AddCard(tc)
	end
	local sg=Duel.GetMatchingGroup(c9911087.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if spchk>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(9911087,0)) then
		Duel.BreakEffect()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			sc:AddCounter(0x1954,1)
			if not g:IsContains(sc) then
				sc:RegisterFlagEffect(9911087,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(9911087,1))
				g:AddCard(sc)
			end
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetOperation(c9911087.rlop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9911087.rlfilter(c,fid)
	return c:GetFlagEffectLabel(9911087)==fid
end
function c9911087.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local rg=g:Filter(c9911087.rlfilter,nil,e:GetLabel())
	g:DeleteGroup()
	if #rg>0 then
		Duel.Hint(HINT_CARD,0,9911087)
		Duel.Release(rg,REASON_EFFECT)
	end
end
