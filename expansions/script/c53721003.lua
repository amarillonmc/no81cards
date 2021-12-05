local m=53721003
local cm=_G["c"..m]
cm.name="悚牢 裂浪号"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+50)
	e3:SetCondition(cm.tdcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.GetDecktopGroup(tp,1)
	g:Merge(g2)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0xa531) and c:IsRace(RACE_FISH) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER)
		and c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(tp)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(cm.cfilter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.stfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local sg=dg:Filter(cm.stfilter,nil,tp)
		local og=dg:Filter(cm.stfilter,nil,1-tp)
		if #sg>1 then Duel.SortDecktop(tp,tp,#sg) end
		if #og>1 then Duel.SortDecktop(tp,1-tp,#og) end
	end
end
