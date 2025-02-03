--传递于云端的思念
function c60001169.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c60001169.wxcon)
	e1:SetTarget(c60001169.wxtg)
	e1:SetOperation(c60001169.wxop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001169,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001169)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c60001169.hstg)
	e2:SetOperation(c60001169.hsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)

	if not c60001169.global_check then
		c60001169.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001169.setcon)
		e4:SetOperation(c60001169.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001169.setter(c)
	return c:IsCode(60001169) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001169.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001169.setter,1,nil)
end
function c60001169.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c60001169.setter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(60001168,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60001169.wxcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c60001169.wxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60001169.wxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if (rc:IsType(TYPE_FIELD) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		if c:GetFlagEffect(60001168)>0 and (c:IsLocation(LOCATION_SZONE) or c:IsPreviousLocation(LOCATION_SZONE)) and rc:IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(60001169,2)) then
			rc:CancelToGrave()
			Duel.MoveToField(rc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			Duel.ChangePosition(rc,POS_FACEDOWN)
			Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
	local code=eg:GetFirst():GetCode()
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetLabel(code)
	e4:SetOperation(c60001169.ntop)
	Duel.RegisterEffect(e4,1-tp)
end
function c60001169.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60001169.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60001169.filter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60001169.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001169.filter2,tp,LOCATION_HAND,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g:FilterSelect(tp,c60001169.filter2,1,1,nil):GetFirst()
			if tc and Duel.SSet(tp,tc)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function c60001169.ntop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if Duel.IsExistingMatchingCard(c60001169.ntfil,tp,LOCATION_DECK,0,1,nil,code) and Duel.SelectYesNo(tp,aux.Stringid(60001169,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60001169.ntfil,tp,LOCATION_DECK,0,1,1,nil,code)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	e:Reset()
end
function c60001169.ntfil(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end