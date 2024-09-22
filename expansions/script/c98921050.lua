--未确认的光顾
function c98921050.initial_effect(c)
	aux.AddCodeList(c,64382839)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921050+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98921050.target)
	e1:SetOperation(c98921050.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921050,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c98921050.tdtg)
	e2:SetOperation(c98921050.tdop)
	c:RegisterEffect(e2)
end
function c98921050.tgfilter(c)
	return c:IsCode(64382839) and c:IsAbleToGrave()
end
function c98921050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local b=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,64382839)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921050.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) or (b and (Duel.IsPlayerCanDraw(tp,2) or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil))) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c98921050.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	local c=e:GetHandler()
	local b=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,64382839)
	local g0=Duel.IsExistingMatchingCard(c98921050.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	local g1=Duel.IsPlayerCanDraw(tp,2)
	local g2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)
	local off=1
	local ops={}
	local opval={}
	if g0 then
		ops[off]=aux.Stringid(98921050,0)
		opval[off-1]=0
		off=off+1
	end
	if b and g1 then
		ops[off]=aux.Stringid(98921050,1)
		opval[off-1]=1
		off=off+1
	end
	if b and g2 then
		ops[off]=aux.Stringid(98921050,2)
		opval[off-1]=2
		off=off+1
	end
	local op=0
	if #ops>1 then
		op=Duel.SelectOption(tp,table.unpack(ops))
	end
	if opval[op]==1 then
		if Duel.Draw(tp,2,REASON_EFFECT)==2 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
	if opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil,tp)
		local rc=tg:GetFirst()
		Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)
	end
	if opval[op]==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98921050.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then 
		   Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c98921050.tdfilter(c)
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,64382839) and not c:IsCode(98921050)) or c:IsCode(64382839) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsAbleToDeck()
end
function c98921050.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c98921050.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98921050.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98921050.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function c98921050.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end