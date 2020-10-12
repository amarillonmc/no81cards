function c82228015.initial_effect(c)  
	c:EnableReviveLimit()  
	--splimit  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e0)  
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCondition(c82228015.sprcon)  
	e1:SetOperation(c82228015.sprop)  
	c:RegisterEffect(e1) 
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228015,1))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c82228015.descost)  
	e2:SetTarget(c82228015.destg)  
	e2:SetOperation(c82228015.desop)  
	c:RegisterEffect(e2)  
	--tohand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82228015,1))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_HAND) 
	e3:SetCountLimit(1,82228015)
	e3:SetCost(c82228015.thcost)  
	e3:SetTarget(c82228015.thtg)  
	e3:SetOperation(c82228015.thop)  
	c:RegisterEffect(e3) 
end  
 
function c82228015.sprfilter(c)  
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost() 
end  

function c82228015.sprcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228015.sprfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler())  
end  

function c82228015.sprop(e,tp,eg,ep,ev,re,r,rp,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c82228015.sprfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  

function c82228015.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,1000) end  
	Duel.PayLPCost(tp,1000)  
end  

function c82228015.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  

function c82228015.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  

function c82228015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.CheckLPCost(tp,1000) end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)  
	Duel.PayLPCost(tp,1000)  
end  

function c82228015.thfilter(c)  
	return not c:IsType(TYPE_MONSTER) and c:IsSetCard(0x290) and c:IsAbleToHand()  
end  

function c82228015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228015.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  

function c82228015.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228015.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
