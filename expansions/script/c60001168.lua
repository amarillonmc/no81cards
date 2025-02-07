--日月交辉之境界点
function c60001168.initial_effect(c)
	aux.AddCodeList(c,60001179)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001168,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c60001168.wxcon)
	e1:SetTarget(c60001168.wxtg)
	e1:SetOperation(c60001168.wxop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001168,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001168)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c60001168.hstg)
	e2:SetOperation(c60001168.hsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)

	if not c60001168.global_check then
		c60001168.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001168.setcon)
		e4:SetOperation(c60001168.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001168.setter(c)
	return c:IsCode(60001168) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001168.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001168.setter,1,nil)
end
function c60001168.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c60001168.setter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(60001168,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60001168.wxcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function c60001168.wxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001168.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60001168.filter(c,tp,code)
	return c:IsCode(60001179) and ((c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()) or (c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) and c:GetOriginalCode()~=code
end
function c60001168.filterx(c)
	return c:IsCode(60001179) and c:IsAbleToHand() 
end
function c60001168.wxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001168.filterx,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	local g2=Duel.GetMatchingGroup(c60001168.filter,tp,LOCATION_DECK,0,nil,tp,sg:GetFirst():GetCode())
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and c:GetFlagEffect(60001168)>0 and (c:IsLocation(LOCATION_SZONE) or c:IsPreviousLocation(LOCATION_SZONE)) and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(60001168,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if tc then
			if tc:IsType(TYPE_MONSTER) then
				Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
				Duel.SSet(tp,tc)
			end
		end
	end
end
function c60001168.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60001168.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60001168.filter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60001168.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001168.filter2,tp,LOCATION_HAND,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g:FilterSelect(tp,c60001168.filter2,1,1,nil):GetFirst()
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