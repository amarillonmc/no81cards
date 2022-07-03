--永夏的缱绻
function c9910974.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910974.flag)
	c:RegisterEffect(e0)
	--reload
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910974,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910974+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910974.drtg)
	e1:SetOperation(c9910974.drop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910974,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9910974+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c9910974.rmtg)
	e2:SetOperation(c9910974.rmop)
	c:RegisterEffect(e2)
end
function c9910974.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910974.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return (Duel.IsPlayerCanDraw(tp) or h1==0)
		and (Duel.IsPlayerCanDraw(1-tp) or h2==0)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,LOCATION_HAND,1,nil,tp,POS_FACEDOWN) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c9910974.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
		local og=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		Duel.BreakEffect()
		local ct1=og:FilterCount(Card.IsPreviousControler,nil,tp)
		local ct2=og:FilterCount(Card.IsPreviousControler,nil,1-tp)
		Duel.Draw(tp,ct1,REASON_EFFECT)
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	end
end
function c9910974.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5954)
end
function c9910974.tgfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsReason(REASON_EFFECT)
end
function c9910974.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910974.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910974.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp,POS_FACEDOWN) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c9910974.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c9910974.filter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if ct>#g then ct=#g end
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c9910974.tgfilter,tp,LOCATION_REMOVED,0,1,ct,nil)
	if #tg==0 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
	local gct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if gct==0 then return end
	Duel.BreakEffect()
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,gct,gct,nil,tp,POS_FACEDOWN)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0
		and sg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local tc=og:GetFirst()
		while tc do
			tc:RegisterFlagEffect(9910974,RESET_EVENT+RESETS_STANDARD,0,1)
			tc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910974.retcon)
		e1:SetOperation(c9910974.retop)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910974.retfilter(c)
	return c:GetFlagEffect(9910974)~=0
end
function c9910974.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and e:GetLabelObject():IsExists(c9910974.retfilter,1,nil)
end
function c9910974.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c9910974.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	g:DeleteGroup()
end
