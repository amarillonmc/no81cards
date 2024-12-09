--核成源武装恐兽
function c49811282.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--link summon
	c:SetSPSummonOnce(49811282)
	aux.AddLinkProcedure(c,c49811282.mfilter,1)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c49811282.drtg)
	e1:SetOperation(c49811282.drop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c49811282.thcost)
	e2:SetTarget(c49811282.thtg)
	e2:SetOperation(c49811282.thop)
	c:RegisterEffect(e2)
end
function c49811282.mfilter(c)
	return c:IsLevelAbove(3) and c:IsLinkSetCard(0x1d)
end
function c49811282.tdfilter(c)
	return aux.IsCodeListed(c,36623431) and c:IsAbleToDeck()
end
function c49811282.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c49811282.tdfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c49811282.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c49811282.tdfilter,tp,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end  
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,#g+1,REASON_EFFECT)
end
function c49811282.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c49811282.chkfilter(c)
	return c:IsOriginalCodeRule(36623431) and not c:IsPublic()
end
function c49811282.thfilter(c)
	return c:IsCode(20457551,59385322,18517177,8057630) and c:IsAbleToHand()
end
function c49811282.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811282.chkfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c49811282.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c49811282.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c49811282.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c49811282.chkfilter,tp,LOCATION_HAND,0,1,ct,nil)
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,#cg,#cg)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
