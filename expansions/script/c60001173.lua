--她眼中璀璨的星辰
function c60001173.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetTarget(c60001173.destg)
	e1:SetOperation(c60001173.desop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001173,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001173)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c60001173.hstg)
	e2:SetOperation(c60001173.hsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)

	if not c60001173.global_check then
		c60001173.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001173.setcon)
		e4:SetOperation(c60001173.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001173.setter(c)
	return c:IsCode(60001173) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001173.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001173.setter,1,nil)
end
function c60001173.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c60001173.setter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(60001168,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60001173.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c60001173.filter(c)
	return c:IsCode(60001179) and c:IsAbleToHand()
end
function c60001173.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g=Duel.GetMatchingGroup(c60001173.filter,tp,LOCATION_DECK,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)>0 and c:GetFlagEffect(60001168)>0 and c:IsLocation(LOCATION_SZONE) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60001173,2)) then
		local fg=Duel.GetOperatedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60001173.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		local code={}
		if #fg==0 then return end
		if #fg==1 then 
			code[1]=fg:GetFirst():GetCode()
			code[2]=0
		elseif #fg==2 then
			code[1]=fg:GetFirst():GetCode()
			fg:RemoveCard(fg:GetFirst())
			code[2]=fg:GetFirst():GetCode()
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e4:SetCountLimit(1)
		e4:SetLabel(code[1],code[2])
		e4:SetOperation(c60001173.ntop)
		Duel.RegisterEffect(e4,1-tp)
	end
end
function c60001173.ntop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code1,code2=e:GetLabel()
	local cg=Duel.GetMatchingGroup(c60001173.ntfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,code1,code2)
	if #cg~=0 and Duel.SelectYesNo(tp,aux.Stringid(60001173,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60001173.ntfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,code1,code2)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	e:Reset()
end
function c60001173.ntfil(c,code1,code2)
	return c:IsAbleToHand() and (c:IsCode(code1) or c:IsCode(code2))
end
function c60001173.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60001173.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60001173.filter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60001173.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001173.filter2,tp,LOCATION_HAND,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g:FilterSelect(tp,c60001173.filter2,1,1,nil):GetFirst()
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