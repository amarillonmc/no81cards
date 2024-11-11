--岭偶电构体·霹雳
function c9911663.initial_effect(c)
	--Activate only search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911663,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911663+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911663.target1)
	e1:SetOperation(c9911663.activate1)
	c:RegisterEffect(e1)
	--Activate when summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911663,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCountLimit(1,9911663+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9911663.condition)
	e2:SetTarget(c9911663.target2)
	e2:SetOperation(c9911663.activate2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	if not c9911663.global_check then
		c9911663.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9911663.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911663.checkfilter(c,tp)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c9911663.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c9911663.checkfilter,1,nil,0) and Duel.GetFlagEffect(0,9911654)==0 then
		Duel.RegisterFlagEffect(0,9911654,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911654,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
	end
	if eg:IsExists(c9911663.checkfilter,1,nil,1) and Duel.GetFlagEffect(1,9911654)==0 then
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
function c9911663.thtgfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911663.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911663.thtgfilter,tp,LOCATION_DECK,0,3,nil) end
end
function c9911663.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911663.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,3,3,nil)
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
function c9911663.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.NegateSummonCondition() and eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetFlagEffect(tp,9911654)>0
end
function c9911663.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	if Duel.IsExistingMatchingCard(c9911663.thtgfilter,tp,LOCATION_DECK,0,3,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(9911663,1),aux.Stringid(9911663,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911663,1))
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c9911663.activate2(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local chk
	if op==1 then
		local g=Duel.GetMatchingGroup(c9911663.thtgfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=g:Select(tp,3,3,nil)
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
	if chk then Duel.BreakEffect() end
	Duel.NegateSummon(eg)
	local ct=Duel.Destroy(eg,REASON_EFFECT)
	if ct==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(ct+1)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end
