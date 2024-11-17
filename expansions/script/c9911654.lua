--岭偶金构体·嬗变
function c9911654.initial_effect(c)
	--Activate only search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911654,4))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911654+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911654.target1)
	e1:SetOperation(c9911654.activate1)
	c:RegisterEffect(e1)
	--Activate rebound target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911654,5))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911654+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9911654.condition)
	e2:SetTarget(c9911654.target2)
	e2:SetOperation(c9911654.activate2)
	c:RegisterEffect(e2)
	if not c9911654.global_check then
		c9911654.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9911654.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911654.flagfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER)
end
function c9911654.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9911654.flagfilter,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(9911654,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911654,1))
	end
	if g:IsExists(Card.IsControler,1,nil,0) and Duel.GetFlagEffect(0,9911654)==0 then
		Duel.RegisterFlagEffect(0,9911654,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911654,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
	end
	if g:IsExists(Card.IsControler,1,nil,1) and Duel.GetFlagEffect(1,9911654)==0 then
		Duel.RegisterFlagEffect(1,9911654,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(9911654,2))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,1)
	end
end
function c9911654.thtgfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911654.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9911654.thtgfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=4
	end
end
function c9911654.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911654.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,4,4)
		Duel.ConfirmCards(1-tp,sg)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c9911654.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911654)>0
end
function c9911654.tdfilter(c)
	return c:IsFaceupEx() and c:IsAbleToDeck()
end
function c9911654.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c9911654.tdfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9911654.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) end
	local op=0
	local g=Duel.GetMatchingGroup(c9911654.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=4 then
		op=Duel.SelectOption(tp,aux.Stringid(9911654,5),aux.Stringid(9911654,6))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911654,5))
	end
	e:SetLabel(op)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9911654.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	if op==0 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_DRAW)
	end
end
function c9911654.activate2(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local chk
	if op==1 then
		local g=Duel.GetMatchingGroup(c9911654.thtgfilter,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)>=4 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,4,4)
			Duel.ConfirmCards(1-tp,sg)
			local tg=sg:RandomSelect(1-tp,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
				tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
			Duel.ShuffleDeck(tp)
			chk=true
		end
	end
	local tc=Duel.GetFirstTarget()
	local res=false
	if tc:IsFaceupEx() and tc:IsSetCard(0x5957) then res=true end
	if tc:IsRelateToEffect(e) then
		if chk then Duel.BreakEffect() end
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
			and res and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9911654,0)) then
			if tc:IsControler(tp) and tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
