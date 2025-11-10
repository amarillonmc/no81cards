--CAN:D 负荷充能！
function c88888219.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888219,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c88888219.target)
	e1:SetOperation(c88888219.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(88888219,1))
	e2:SetCost(c88888219.cost)
	e2:SetOperation(c88888219.activate2)
	c:RegisterEffect(e2)
end
function c88888219.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c88888219.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888219.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88888219.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88888219.setfilter(c)
	return c:IsSetCard(0x8908) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c88888219.spfilter(c,e,tp)
	return c:IsSetCard(0x8908) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c88888219.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8908) and not c:IsType(TYPE_TOKEN)
end
function c88888219.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c88888219.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c88888219.mfilter,tp,LOCATION_MZONE,0,nil)
	local b1=(Duel.GetFlagEffect(tp,88888219)==0 or not e:IsCostChecked()) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c88888219.setfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=(Duel.GetFlagEffect(tp,18888219)==0 or not e:IsCostChecked())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c88888219.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b3=(Duel.GetFlagEffect(tp,28888219)==0 or not e:IsCostChecked())
		and Duel.IsExistingMatchingCard(c88888219.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(88888219,2),1},
		{b2,aux.Stringid(88888219,3),2},
		{b3,aux.Stringid(88888219,4),3})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(0)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,88888219,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,18888219,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==3 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,28888219,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c88888219.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c88888219.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888219.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	elseif op==3 then
		local g=Duel.GetMatchingGroup(c88888219.mfilter,tp,LOCATION_MZONE,0,nil)
		local xyzg=Duel.GetMatchingGroup(c88888219.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,g,1,6)
		end
	end
end
function c88888219.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c88888219.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888219.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	elseif op==3 then
		local g=Duel.GetMatchingGroup(c88888219.mfilter,tp,LOCATION_MZONE,0,nil)
		local xyzg=Duel.GetMatchingGroup(c88888219.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,g,1,6)
		end
	end
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end