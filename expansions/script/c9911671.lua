--岭偶岩构体·玉壁
function c9911671.initial_effect(c)
	--Activate only search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911671,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911671+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911671.target1)
	e1:SetOperation(c9911671.activate1)
	c:RegisterEffect(e1)
	--Activate recycle GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911671,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911671+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9911671.condition)
	e2:SetTarget(c9911671.target2)
	e2:SetOperation(c9911671.activate2)
	c:RegisterEffect(e2)
	if not c9911671.global_check then
		c9911671.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9911671.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911671.checkfilter(c,tp)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c9911671.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9911671.checkfilter,1,nil,0) and Duel.GetFlagEffect(0,9911654)==0 then
		Duel.RegisterFlagEffect(0,9911654,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911654,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
	end
	if eg:IsExists(c9911671.checkfilter,1,nil,1) and Duel.GetFlagEffect(1,9911654)==0 then
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
function c9911671.thtgfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911671.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9911671.thtgfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function c9911671.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911671.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
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
function c9911671.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911654)>0
end
function c9911671.setfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsReason(REASON_RETURN) and c:IsSSetable()
end
function c9911671.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911671.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local op=0
	local g=Duel.GetMatchingGroup(c9911671.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		op=Duel.SelectOption(tp,aux.Stringid(9911671,1),aux.Stringid(9911671,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911671,1))
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_LEAVE_GRAVE)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_LEAVE_GRAVE)
	end
end
function c9911671.gselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and #g-fc<=ft and g:GetClassCount(Card.GetTurnID)==#g
end
function c9911671.activate2(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local chk
	if op==1 then
		local g=Duel.GetMatchingGroup(c9911671.thtgfilter,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
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
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911671.setfilter),tp,LOCATION_GRAVE,0,nil)
	if #g2==0 then return end
	if chk then Duel.BreakEffect() end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg2=g2:SelectSubGroup(tp,c9911671.gselect,false,1,ft+1,ft)
	if Duel.SSet(tp,tg2)==0 then return end
	local tc=tg2:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		tc=tg2:GetNext()
	end
end
