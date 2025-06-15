--欢聚友伴 发黑锃亮双马尾
function c98500010.initial_effect(c)
	Duel.AddCustomActivityCounter(98500010,ACTIVITY_CHAIN,c98500010.chainfilter)
	Duel.AddCustomActivityCounter(98500011,ACTIVITY_CHAIN,c98500010.chainfilter2)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98500010.drcon)
	e1:SetCost(c98500010.drcost)
	e1:SetOperation(c98500010.drop)
	c:RegisterEffect(e1)
	--adjust(disablecheck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0xff)
	e2:SetLabelObject(e1)
	e2:SetOperation(c98500010.adjustop)
	c:RegisterEffect(e2)
end
function c98500010.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1b2))
end
function c98500010.chainfilter2(re,tp,cid)
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc&(LOCATION_HAND|LOCATION_GRAVE|LOCATION_REMOVED)>0 then
		Duel.RegisterFlagEffect(1-tp,98500010,RESET_PHASE+PHASE_END,0,1)
	end
	return not (re:IsActiveType(TYPE_MONSTER) and loc&(LOCATION_HAND|LOCATION_GRAVE|LOCATION_REMOVED)>0)
end
function c98500010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 or Duel.GetFlagEffect(tp,98500010)>=4) and Duel.GetCustomActivityCount(98500010,tp,ACTIVITY_CHAIN)<2
end
function c98500010.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c98500010.actcon)
	e3:SetValue(c98500010.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c98500010.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCustomActivityCount(98500010,tp,ACTIVITY_CHAIN)>1
end
function c98500010.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1b2)
end
function c98500010.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c98500010.tdcon)
	e1:SetOperation(c98500010.tdop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetTurnPlayer()==tp then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetOperation(c98500010.rmop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c98500010.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98500010)>=4
end
function c98500010.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,98500010)
	local ct2=math.floor(ct/5)
	local g=Duel.GetFieldGroup(e:GetOwnerPlayer(),0,LOCATION_ONFIELD):Filter(Card.IsAbleToDeck,nil)
	local g2=Duel.GetFieldGroup(e:GetOwnerPlayer(),0,LOCATION_HAND):Filter(Card.IsAbleToDeck,nil)
	if ct2>g:GetCount() then
		local ct3=ct2-g:GetCount()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local mg=g:Select(1-tp,1,ct2,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local mg2=g2:Select(1-tp,1,ct3,nil)
		mg:Merge(mg2)
		Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local mg=g:Select(1-tp,1,ct2,nil)
		Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c98500010.rmop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and (re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND) then
		local rc=re:GetHandler()
		Duel.Hint(HINT_CARD,0,98500010)
		Duel.SendtoDeck(rc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
function c98500010.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,98500010)>=4 and Duel.GetTurnPlayer()==tp then
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
