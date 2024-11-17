--岭偶澄构体·沉积
function c9911662.initial_effect(c)
	--Activate only search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911662,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911662+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911662.target1)
	e1:SetOperation(c9911662.activate1)
	c:RegisterEffect(e1)
	--Activate set monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911662,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9911662+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9911662.condition)
	e2:SetTarget(c9911662.target2)
	e2:SetOperation(c9911662.activate2)
	c:RegisterEffect(e2)
	if not c9911662.global_check then
		c9911662.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9911662.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911662.checkfilter(c,tp)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c9911662.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9911662.checkfilter,1,nil,0) and Duel.GetFlagEffect(0,9911654)==0 then
		Duel.RegisterFlagEffect(0,9911654,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911654,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
	end
	if eg:IsExists(c9911662.checkfilter,1,nil,1) and Duel.GetFlagEffect(1,9911654)==0 then
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
function c9911662.thtgfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911662.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9911662.thtgfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
end
function c9911662.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911662.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
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
function c9911662.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911654)>0
end
function c9911662.mfilter(c,e)
	return c:GetSequence()<=4 and not (e and c:IsImmuneToEffect(e))
end
function c9911662.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911662.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,nil) end
	local op=0
	local g=Duel.GetMatchingGroup(c9911662.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		op=Duel.SelectOption(tp,aux.Stringid(9911662,1),aux.Stringid(9911662,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911662,1))
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	end
end
function c9911662.sfilter(c,seq)
	return c:GetSequence()==seq
end
function c9911662.activate2(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local chk
	if op==1 then
		local g=Duel.GetMatchingGroup(c9911662.thtgfilter,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
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
	local mg=Duel.GetMatchingGroup(c9911662.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if #mg==0 then return end
	if chk then Duel.BreakEffect() end
	for tc in aux.Next(mg) do
		local zone=1<<tc:GetSequence()
		local oc=Duel.GetMatchingGroup(c9911662.sfilter,tc:GetControler(),LOCATION_SZONE,0,nil,tc:GetSequence()):GetFirst()
		if oc then
			Duel.Destroy(oc,REASON_RULE)
		end
		if Duel.MoveToField(tc,tp,tc:GetControler(),LOCATION_SZONE,POS_FACEUP,true,zone) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	end
end
