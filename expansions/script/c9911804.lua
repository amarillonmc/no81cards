--聚薪烬灵
function c9911804.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911804)
	e1:SetCondition(c9911804.spcon)
	e1:SetTarget(c9911804.sptg)
	e1:SetOperation(c9911804.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9911804.reptg)
	c:RegisterEffect(e2)
	--destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9911804.dedcon)
	e3:SetTarget(c9911804.dedtg)
	e3:SetOperation(c9911804.dedop)
	c:RegisterEffect(e3)
end
function c9911804.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c9911804.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911804.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911804,0xa957,TYPE_MONSTER+TYPE_EFFECT+TYPE_TUNER,1200,1000,3,RACE_PYRO,ATTRIBUTE_FIRE) and Duel.IsExistingMatchingCard(c9911804.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_SZONE)
end
function c9911804.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911804.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911804.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGrave()
end
function c9911804.disfilter(c,e)
	return aux.NegateAnyFilter(c) and not c:IsImmuneToEffect(e)
end
function c9911804.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,9911804)==0 and Duel.IsExistingMatchingCard(c9911804.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,9911805)==0 and Duel.IsExistingMatchingCard(c9911804.disfilter,tp,0,LOCATION_ONFIELD,1,nil,e)
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and (b1 or b2) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_CARD,0,9911804)
		local op=0
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911804,0),1},{b2,aux.Stringid(9911804,1),2})
		if op==1 then
			Duel.RegisterFlagEffect(tp,9911804,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c9911804.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REPLACE)
		elseif op==2 then
			Duel.RegisterFlagEffect(tp,9911805,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local g=Duel.SelectMatchingCard(tp,c9911804.disfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e)
			local dc=g:GetFirst()
			if dc then
				Duel.HintSelection(g)
				Duel.BreakEffect()
				Duel.NegateRelatedChain(dc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				dc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				dc:RegisterEffect(e2)
				if dc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					dc:RegisterEffect(e3)
				end
			end
			Duel.AdjustAll()
		end
		return true
	else return false end
end
function c9911804.dedcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9911804.dedtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,9911804)==0 and Duel.IsExistingMatchingCard(c9911804.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,9911805)==0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911804,0),1},{b2,aux.Stringid(9911804,1),2})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.RegisterFlagEffect(tp,9911804,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.RegisterFlagEffect(tp,9911805,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end
function c9911804.dedop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c9911804.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g==0 then return end
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
