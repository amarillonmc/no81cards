function c82228007.initial_effect(c)   
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x290),2,2)
	--destroy  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228007,0))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,82228007)  
	e1:SetTarget(c82228007.destg)  
	e1:SetOperation(c82228007.desop)  
	c:RegisterEffect(e1)  
	--search 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228007,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_LEAVE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82238007)  
	e2:SetCondition(c82228007.thcon)  
	e2:SetTarget(c82228007.thtg)  
	e2:SetOperation(c82228007.thop)  
	c:RegisterEffect(e2)  
end 

function c82228007.desfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_INSECT) 
end  

function c82228007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	if chk==0 then return Duel.IsExistingTarget(c82228007.desfilter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g1=Duel.SelectTarget(tp,c82228007.desfilter,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)  
	g1:Merge(g2)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)  
end  

function c82228007.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)  
	if tg:GetCount()>0 then  
		Duel.Destroy(tg,REASON_EFFECT)  
	end  
end  
 
function c82228007.thcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)  
end  
 
function c82228007.thfilter(c,e,tp)  
	return c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end  
 
function c82228007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228007.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end  
 
function c82228007.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228007.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  