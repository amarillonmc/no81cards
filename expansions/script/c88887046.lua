--龟影迷踪法 暗中设伏
function c88887046.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88887046)
	e1:SetTarget(c88887046.target)
	e1:SetOperation(c88887046.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c88887046.desreptg)
	e2:SetValue(c88887046.desrepval)
	e2:SetOperation(c88887046.desrepop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CUSTOM+88887046)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,18887046)
	e3:SetCondition(c88887046.tdcon)
	e3:SetCost(c88887046.tdcost)
	e3:SetTarget(c88887046.tdtg)
	e3:SetOperation(c88887046.tdop)
	c:RegisterEffect(e3)
	aux.RegisterMergedDelayedEvent(c,88887046,EVENT_SPSUMMON_SUCCESS)
end
function c88887046.thfilter(c)
	return c:IsSetCard(0x885) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88887046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88887046.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88887046.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88887046.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c88887046.tdfilter(c,tp)
	return c:IsSummonLocation(LOCATION_DECK) and c:IsSummonPlayer(1-tp) and c:IsAbleToDeck() and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function c88887046.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88887046.tdfilter,1,nil,tp)
end
function c88887046.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c88887046.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c88887046.tdfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.IsInGroup(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
end
function c88887046.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c88887046.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c88887046.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c88887046.repfilter,1,nil,tp)
		and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and c:IsAbleToDeck() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c88887046.desrepval(e,c)
	return c88887046.repfilter(c,e:GetHandlerPlayer())
end
function c88887046.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,88887046)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end