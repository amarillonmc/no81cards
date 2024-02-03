--触影的永夏 空门苍
function c9910957.initial_effect(c)
	c:EnableCounterPermit(0x6954)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910957,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910957)
	e1:SetCondition(c9910957.spcon)
	e1:SetTarget(c9910957.sptg)
	e1:SetOperation(c9910957.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910958)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c9910957.thtg)
	e2:SetOperation(c9910957.thop)
	c:RegisterEffect(e2)
end
function c9910957.togfilter(c)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK)
end
function c9910957.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910957.togfilter,1,nil)
end
function c9910957.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local pchk=0
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END then pchk=1 end
	e:SetLabel(pchk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910957.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetLabel()==1 then
		Duel.BreakEffect()
		c:AddCounter(0x6954,1)
	end
end
function c9910957.csfilter(c,e,tp)
	if c:IsType(TYPE_TOKEN) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res
end
function c9910957.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
		and (c9910957.csfilter(c,e,tp) or (c:GetCounter(0x6954)>0 and c:IsAbleToRemove())) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910957.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=c9910957.csfilter(c,e,tp)
	local b2=c:GetCounter(0x6954)>0 and c:IsAbleToRemove()
	local res=false
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910957,1),aux.Stringid(9910957,2))==0) then
		res=Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.ConfirmCards(1-tp,c)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	elseif b2 then
		local fid=c:GetFieldID()
		if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED)
			and not c:IsReason(REASON_REDIRECT) then
			res=true
			c:RegisterFlagEffect(9910957,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			if Duel.GetCurrentPhase()==PHASE_END then
				e2:SetLabel(fid,Duel.GetTurnCount())
				e2:SetReset(RESET_PHASE+PHASE_END,2)
			else
				e2:SetLabel(fid,0)
				e2:SetReset(RESET_PHASE+PHASE_END)
			end
			e2:SetLabelObject(c)
			e2:SetCondition(c9910957.retcon)
			e2:SetOperation(c9910957.retop)
			Duel.RegisterEffect(e2,tp)
		end
	end
	if res then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c9910957.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	if tc:GetFlagEffectLabel(9910957)~=lab1 then
		e:Reset()
		return false
	else return Duel.GetTurnCount()~=lab2 end
end
function c9910957.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
