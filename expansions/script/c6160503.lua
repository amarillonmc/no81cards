--破碎世界 永恒之核
function c6160503.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,6160503)  
	e1:SetCondition(c6160503.condition) 
	e1:SetOperation(c6160503.activate)  
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160503,0))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,6160503)  
	e2:SetCondition(aux.exccon)  
	e2:SetCost(aux.bfgcost)  
	e2:SetTarget(c6160503.thtg)  
	e2:SetOperation(c6160503.thop)  
	c:RegisterEffect(e2)   
end 
function c6160503.cfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsRace(RACE_SPELLCASTER)
end  
function c6160503.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c6160503.cfilter,tp,LOCATION_ONFIELD,0,1,nil)  
end  
function c6160503.thfilter(c)  
	return c:IsRace(RACE_SPELLCASTER)
end   
function c6160503.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(c6160503.thfilter,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,sg)  
	end  
end  
function c6160503.hdfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x616) and c:IsAbleToHand() 
end
function c6160503.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6160503.hdfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160503.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local sg=Duel.SelectTarget(tp,c6160503.hdfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)  
end  
function c6160503.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  