--宝具-光壳流溢的虚树
function c9950962.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950962+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9950962.target)
	e1:SetOperation(c9950962.activate)
	c:RegisterEffect(e1)
  --act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c9950962.actcon)
	c:RegisterEffect(e2)
 --attack target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950962,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9950962.tgtg)
	e2:SetOperation(c9950962.tgop)
	c:RegisterEffect(e2)
end
function c9950962.actcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c9950962.filter(c)
	return c:IsSetCard(0x9ba7) and not c:IsCode(9950962) and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function c9950962.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9950962.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9950962.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950962.filter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,3,3)
	aux.GCheckAdditional=nil
	local cg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950962,0))
end
function c9950962.thfilter(c)
	return c:IsSetCard(0x9ba7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950962.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c9950962.thfilter,tp,LOCATION_DECK,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950962.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
	   local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950962.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
