--龗龘龘龘
function c11185075.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11185075+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11185075.target)
	e1:SetOperation(c11185075.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_RELEASE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c11185075.cost2)
	e2:SetTarget(c11185075.target2)
	e2:SetOperation(c11185075.operation2)
	c:RegisterEffect(e2)
end
function c11185075.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c11185075.opfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5450)
end
function c11185075.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185075.opfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c11185075.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11185075.opfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local b1=tc:IsAbleToRemove()
		local b2=tc:IsReleasableByEffect()
		local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(11185075,7)},
			{true,aux.Stringid(11185075,8)},
			{b1,aux.Stringid(11185075,9)},
			{b2,aux.Stringid(11185075,10)})
		if op==1 then
			Duel.SendtoGrave(tc,0x40)
		elseif op==2 then
			Duel.Destroy(tc,0x40)
		elseif op==3 then
			Duel.Remove(tc,0x5,0x40)
		elseif op==4 then
			Duel.Release(tc,0x40)
		end
	end
end
function c11185075.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON+RACE_DINOSAUR+RACE_SEASERPENT+RACE_WYRM) and c:IsFaceupEx()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11185075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c11185075.filter,tp,0x30,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end
function c11185075.splimit(e,c)
	return not c:IsSetCard(0x5450)
end
function c11185075.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetTargetRange(1,0)
		e0:SetTarget(c11185075.splimit)
		if Duel.GetTurnPlayer()==tp then
			e0:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e0:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e0,tp)
		local e00=e0:Clone()
		e00:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e00,tp)
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11185075.filter),tp,0x30,0,1,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_DEFENSE)
			e4:SetValue(0)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
		end
		tc=g:GetNext()
	end
	if Duel.SpecialSummonComplete()<1 then return end
	local b1=Duel.IsExistingMatchingCard(c11185075.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c11185075.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c11185075.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=c11185075.fufilter(e,tp)
	if (b1 or b2 or b3 or b4) and Duel.SelectYesNo(tp,aux.Stringid(11185075,0)) then
		Duel.BreakEffect()
		c11185075.spop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c11185075.xfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x5450)
end
function c11185075.sfilter(c)
	return c:IsSynchroSummonable(nil)and c:IsSetCard(0x5450)
end
function c11185075.lfilter(c)
	return c:IsLinkSummonable(nil)and c:IsSetCard(0x5450)
end
function c11185075.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c11185075.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x5450)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function c11185075.fufilter(e,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local res=Duel.IsExistingMatchingCard(c11185075.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11185075.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
end
function c11185075.spop(e,tp,eg,ep,ev,re,r,rp)
	local id=11185075
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c11185075.sfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c11185075.xfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c11185075.lfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b4=c11185075.fufilter(e,tp)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,5)
		opval[off-1]=3
		off=off+1
	end
	 if b4 then
		ops[off]=aux.Stringid(id,6)
		opval[off-1]=4
		off=off+1
	end  
	local op=Duel.SelectOption(tp,table.unpack(ops)) 
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11185075.sfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.SynchroSummon(tp,g:GetFirst(),nil)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11185075.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.XyzSummon(tp,g:GetFirst(),nil)
	elseif opval[op]==3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11185075.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.LinkSummon(tp,g:GetFirst(),nil)
	else 
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c11185075.filter1,nil,e):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local sg1=Duel.GetMatchingGroup(c11185075.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c11185075.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
end