--团团圆圆 多彩团子
function c62501186.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62501186)
	e1:SetTarget(c62501186.target)
	e1:SetOperation(c62501186.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501186,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,62501186)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c62501186.tdtg)
	e2:SetOperation(c62501186.tdop)
	c:RegisterEffect(e2)
end
function c62501186.thfilter(c,chk)
	return (chk==0 and c:IsSetCard(0xea1) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() or chk==1 and c:IsLevel(1)) and c:IsAbleToHand()
end
function c62501186.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501186.thfilter,tp,LOCATION_DECK+0x20,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c62501186.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501186.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,0):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501186,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c62501186.tdfilter(c)
	return c:IsSetCard(0xea1) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeck()
end
function c62501186.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c62501186.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62501186.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(c62501186.thfilter,tp,LOCATION_DECK,0,1,nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,c62501186.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
end
function c62501186.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501186.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local g=Duel.GetTargetsRelateToChain()
		if #g>0 then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end
