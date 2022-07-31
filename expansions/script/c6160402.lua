--破碎世界的隐士
function c6160402.initial_effect(c) 
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,4,c6160402.lcheck)  
	c:EnableReviveLimit()  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160402,0))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,6160402)
	e1:SetCost(c6160402.cost)  
	e1:SetTarget(c6160402.target)  
	e1:SetOperation(c6160402.operation) 
	c:RegisterEffect(e1)
end
function c6160402.lcheck(g)  
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x616)
end  
function c6160402.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function c6160402.tgfilter(c)  
	return c:IsSetCard(0x616)
end  
function c6160402.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6160402.tgfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)  
end  
function c6160402.operation(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c6160402.tgfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end  