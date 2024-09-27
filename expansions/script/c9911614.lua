--忘却王陵
function c9911614.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911614,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9911614.distg)
	e2:SetOperation(c9911614.disop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911614,1))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9911614+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c9911614.reccost)
	e3:SetTarget(c9911614.rectg)
	e3:SetOperation(c9911614.recop)
	c:RegisterEffect(e3)
	--check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c9911614.regop)
	c:RegisterEffect(e4)
	if not c9911614.global_check then
		c9911614.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9911614.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c9911614.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9911614.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsOnField,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911615,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911614,4))
		end
	end
end
function c9911614.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9911614.ctgfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911615,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911614,4))
		end
	end
end
function c9911614.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(9911615)==0
end
function c9911614.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetMaterialCount()>0
		and c:GetFlagEffect(9911615)==0
end
function c9911614.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9911614.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911614.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9911614.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
end
function c9911614.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if sc:IsFacedown() or not sc:IsRelateToEffect(e) then return end
	local ct=sc:GetMaterialCount()
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if #tg==0 then return end
	for tc in aux.Next(tg) do
		if tc:IsCanBeDisabledByEffect(e,false) then
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
end
function c9911614.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9911614.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsStatus(STATUS_EFFECT_ENABLED) and c:IsAbleToRemove() end
	local ct=c:GetFlagEffectLabel(9911614)
	if not ct then ct=0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,(ct+1)*2500)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function c9911614.filter1(c)
	return c:IsFaceup() and (c:IsAbleToHand() or c9911614.filter2(c))
end
function c9911614.filter2(c)
	return c:IsReason(REASON_TEMPORARY) and not c:IsReason(REASON_REDIRECT) and c:GetPreviousLocation()&LOCATION_ONFIELD>0
		and c9911614.retfilter(c)
end
function c9911614.retfilter(c)
	local p=c:GetPreviousControler()
	local pft=0
	if Duel.CheckLocation(p,LOCATION_PZONE,0) then pft=pft+1 end
	if Duel.CheckLocation(p,LOCATION_PZONE,1) then pft=pft+1 end
	if c:IsPreviousLocation(LOCATION_MZONE) then
		return Duel.GetLocationCount(p,LOCATION_MZONE)>0
	elseif c:IsPreviousLocation(LOCATION_FZONE) then
		return true
	elseif c:IsPreviousLocation(LOCATION_PZONE) then
		return pft>0
	else
		return Duel.GetLocationCount(p,LOCATION_SZONE)>0
	end
end
function c9911614.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local ct=c:GetFlagEffectLabel(9911614)
	if not ct then ct=0 end
	if Duel.Recover(tp,(ct+1)*2500,REASON_EFFECT)>0 and c:IsAbleToRemove()
		and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		if not c:IsReason(REASON_REDIRECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c9911614.retop1)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.AdjustAll()
		local g=Duel.GetMatchingGroup(c9911614.filter1,tp,LOCATION_REMOVED,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9911614,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local dg=Duel.SelectMatchingCard(tp,c9911614.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
			local tc=dg:GetFirst()
			if not tc then return end
			Duel.HintSelection(dg)
			local op=aux.SelectFromOptions(tp,{tc:IsAbleToHand(),1190},{c9911614.filter2(tc),aux.Stringid(9911614,3)})
			if op==1 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
			if op==2 then
				c9911614.returntofield(tc,e)
				Duel.RaiseEvent(tc,9911614,e,0,0,0,0)
			end
		end
	end
end
function c9911614.retop1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	if Duel.GetTurnCount()~=e:GetLabel() and ec:IsLocation(LOCATION_REMOVED) then
		Duel.ReturnToField(e:GetLabelObject())
	end
end
function c9911614.returntofield(tc,e)
	if tc:IsPreviousLocation(LOCATION_FZONE) then
		local p=tc:GetPreviousControler()
		local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if gc then
			Duel.SendtoGrave(gc,REASON_RULE)
			Duel.BreakEffect()
		end
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		local rc=tc:GetReasonEffect():GetOwner() or tc
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(9911614)
		e1:SetLabelObject(tc)
		e1:SetOperation(c9911614.retop2)
		Duel.RegisterEffect(e1,0)
	end
end
function c9911614.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
function c9911614.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(9911614)
	if not ct then
		c:RegisterFlagEffect(9911614,RESET_EVENT+RESETS_STANDARD,0,1,1)
	else
		c:SetFlagEffectLabel(9911614,ct+1)
	end
end
