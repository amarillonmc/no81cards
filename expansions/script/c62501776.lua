--蚀痕无命 痕印之誓
function c62501776.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(62501776,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(c62501776.excost)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DISABLE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c62501776.condition)
	e1:SetCost(c62501776.cost)
	e1:SetTarget(c62501776.target)
	e1:SetOperation(c62501776.activate)
	c:RegisterEffect(e1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501776+1)
	e4:SetTarget(c62501776.tdtg)
	e4:SetOperation(c62501776.tdop)
	c:RegisterEffect(e4)
	c62501776.remove_event_effect=e4
end
function c62501776.extfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckAsCost()
end
function c62501776.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c62501776.extfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c62501776.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c62501776.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.DisableShuffleCheck()
	Duel.ConfirmDecktop(tp,3)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c62501776.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local b1=Duel.IsChainNegatable(ev) and (rc:IsAbleToRemove(tp,POS_FACEDOWN) or not re:GetHandler():IsRelateToChain(ev))--Duel.IsPlayerCanRemove(tp,rc)
	local b2=Duel.IsChainDisablable(ev) and (rc:IsAbleToDeck() or not re:GetHandler():IsRelateToChain(ev))
	if chk==0 then return b1 or b2 end
end
function c62501776.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local b1=Duel.IsChainNegatable(ev) and (rc:IsAbleToRemove(tp,POS_FACEDOWN) or not re:GetHandler():IsRelateToChain(ev))--Duel.IsPlayerCanRemove(tp,rc)
	local b2=Duel.IsChainDisablable(ev) and (rc:IsAbleToDeck() or not re:GetHandler():IsRelateToChain(ev))
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(62501776,1),1},
			{b2,aux.Stringid(62501776,2),2})
	if op==1 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToChain(ev) then
			Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
		end
	elseif op==2 then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToChain(ev) then
			Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function c62501776.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck() and not c:IsCode(62501776)
end
function c62501776.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501776.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c62501776.cfilter(c)
	return c:IsSetCard(0xea4) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c62501776.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c62501776.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.ConfirmCards(1-tp,tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetDecktopGroup(1-tp,3)
		if Duel.IsExistingMatchingCard(c62501776.cfilter,tp,LOCATION_MZONE,0,1,nil)
			and g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==3
			and Duel.SelectYesNo(tp,aux.Stringid(62501776,3)) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.ConfirmDecktop(1-tp,3)
			if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==0 then return end
			local og=Duel.GetOperatedGroup()
			og:KeepAlive()
			for tc in aux.Next(og) do tc:RegisterFlagEffect(62501776,RESET_EVENT+RESETS_STANDARD,0,1) end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(og)
			e1:SetCondition(c62501776.retcon)
			e1:SetOperation(c62501776.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c62501776.retfilter(c)
	return c:GetFlagEffect(62501776)~=0
end
function c62501776.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c62501776.retfilter,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c62501776.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
