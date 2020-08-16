--魔界数学家·拉普拉斯妖
function c49966683.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49966683,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c49966683.target)
	e1:SetOperation(c49966683.operation)
	c:RegisterEffect(e1)
	 --search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49966683,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,49966683)
	e4:SetTarget(c49966683.thtg)
	e4:SetOperation(c49966683.thop)
	c:RegisterEffect(e4)
end
function c49966683.tgfilter(c)
	return c:IsLevelBelow(4) and c:IsAbleToRemove()
end
function c49966683.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49966683.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c49966683.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c49966683.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		 Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c49966683.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c49966683.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49966683.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49966683.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c49966683.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	  and  Duel.ConfirmCards(1-tp,g)
	then return end 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
	end
end