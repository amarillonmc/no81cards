--歌声随风渐远散去
function c60001174.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c60001174.ckcon)
	e1:SetTarget(c60001174.cktg)
	e1:SetOperation(c60001174.ckop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001174,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001174)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c60001174.hstg)
	e2:SetOperation(c60001174.hsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)

	if not c60001174.global_check then
		c60001174.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001174.setcon)
		e4:SetOperation(c60001174.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001174.setter(c)
	return c:IsCode(60001174) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001174.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001174.setter,1,nil)
end
function c60001174.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c60001174.setter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(60001168,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60001174.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c60001174.ckcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c60001174.cfilter,1,nil,tp)
end
function c60001174.cktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60001174.ckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and c:GetFlagEffect(60001168)>0 and c:IsLocation(LOCATION_SZONE) and Duel.SelectYesNo(tp,aux.Stringid(60001174,2)) then
		Duel.Recover(tp,2000,REASON_EFFECT)
	end
end
function c60001174.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60001174.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60001174.filter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60001174.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001174.filter2,tp,LOCATION_HAND,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g:FilterSelect(tp,c60001174.filter2,1,1,nil):GetFirst()
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