function c82228008.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(c82228008.cost) 
	e1:SetCountLimit(1,82228008)
	e1:SetTarget(c82228008.target)  
	e1:SetOperation(c82228008.activate)  
	c:RegisterEffect(e1)  
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228008,1))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e1:SetCountLimit(1,82238008)
	e2:SetCost(c82228008.thcost)  
	e2:SetTarget(c82228008.thtg)  
	e2:SetOperation(c82228008.thop)  
	c:RegisterEffect(e2)  
end  

function c82228008.cfilter(c)  
	return c:IsDiscardable() and c:IsSetCard(0x290) 
end  
 
function c82228008.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228008.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.DiscardHand(tp,c82228008.cfilter,1,1,REASON_COST+REASON_DISCARD)  
end  

function c82228008.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(2)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)  
end  
 
function c82228008.activate(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
 
function c82228008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()  
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
 
function c82228008.filter2(c)  
	return c:IsSetCard(0x290) and c:IsLevelBelow(4) and c:IsAbleToHand()  
end  
 
function c82228008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228008.filter2,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
 
function c82228008.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228008.filter2,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  