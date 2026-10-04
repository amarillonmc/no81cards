--命运弦音
function c43990966.initial_effect(c)
	 --fusion
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{43990967,43990987},aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,true,true)
	aux.AddContactFusionProcedure(c,c43990966.mfilter,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.ContactFusionSendToDeck(c)):SetCountLimit(1,43990966+EFFECT_COUNT_CODE_OATH)
	--todeck and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990966,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c43990966.drtg)
	e1:SetOperation(c43990966.drop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_EXTRA))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c43990966.efilter)
	c:RegisterEffect(e2)
end
function c43990966.mfilter(c)
	return (c:IsFusionCode(43990967,43990987) or c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost() and (c:IsFaceupEx() or c:IsOnField())
end
function c43990966.tdfilter(c)
	return aux.IsCodeListed(c,43990987) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c43990966.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c43990966.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c43990966.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c43990966.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c43990966.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c43990966.efilter(e,te,c)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end
