--PSY骨架电光强袭
function c30002035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c30002035.cost)
	e1:SetTarget(c30002035.target)
	e1:SetOperation(c30002035.activate)
	c:RegisterEffect(e1)
	--attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c30002035.tgcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c30002035.tgtg)
	e2:SetOperation(c30002035.tgop)
	c:RegisterEffect(e2)
end
function c30002035.cfilter(c,lv)
	return c:IsSetCard(0xc1) and c:GetOriginalLevel()==lv and c:IsAbleToGraveAsCost()
end
function c30002035.filter(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c30002035.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,lv)
end
function c30002035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c30002035.filter2(c,lv)
	return c:IsLevel(lv) and c:IsFaceup()
end
function c30002035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c30002035.filter2(chkc,e:GetLabel()) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c30002035.filter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c30002035.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local lv=g:GetFirst():GetLevel()
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c30002035.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c30002035.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(30002036,0,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCondition(c30002035.discon)
		e1:SetOperation(c30002035.disop)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c30002035.egfilter(c,lv)
	return c:IsOriginalCodeRule(lv) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c30002035.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(30002036)==e:GetLabel() then
		if not eg:IsContains(tc) then return false end
		if not tc:IsReason(REASON_TEMPORARY) then tc:ResetFlagEffect(30002036) end
		return true
	else
		e:Reset()
		return false
	end
end
function c30002035.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,30002035)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if tc then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	end
end
function c30002035.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()~=tp and aux.bpcon()
end
function c30002035.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc1) and c:GetFlagEffect(30002035)==0
end
function c30002035.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c30002035.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c30002035.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c30002035.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c30002035.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(c30002035.atklimit)
		e1:SetLabel(tc:GetRealFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(30002035,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,0)
	end
end
function c30002035.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
