function c82224013.initial_effect(c)   
	--spSummonrule 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e1:SetCountLimit(1,82224013)  
	e1:SetOperation(c82224013.sprop)
	e1:SetCondition(c82224013.sprcon)  
	c:RegisterEffect(e1) 
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82224013,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82234013)  
	e2:SetCost(c82224013.thcost)  
	e2:SetTarget(c82224013.thtg)  
	e2:SetOperation(c82224013.thop)  
	c:RegisterEffect(e2)  
end
function c82224013.sprfilter(c)  
	return c:IsAbleToDeckAsCost() 
end  
function c82224013.sprcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82224013.sprfilter,tp,LOCATION_HAND,0,1,e:GetHandler())  
end  
function c82224013.sprop(e,tp,eg,ep,ev,re,r,rp,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,c82224013.sprfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())  
	Duel.SendtoDeck(g,nil,1,REASON_COST)  
end  
function c82224013.thfilter(c)  
	return c:IsSetCard(0xdf) and c:IsAbleToHand()  
end  
function c82224013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0xdf) end  
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0xdf)  
	Duel.Release(g,REASON_COST)  
end  
function c82224013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82224013.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82224013.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82224013.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  