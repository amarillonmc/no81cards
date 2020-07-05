local m=82206031
local cm=_G["c"..m]
cm.name="植占师11-冰川"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),4,2)  
	c:EnableReviveLimit()
	--negate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_NEGATE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e1:SetCondition(cm.negcon)
	e1:SetCountLimit(1) 
	e1:SetTarget(cm.negtg)  
	e1:SetOperation(cm.negop)  
	c:RegisterEffect(e1) 
	--search  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCost(cm.thcost)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)  
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_ZOMBIE) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end  
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateActivation(ev) 
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x129d) and c:IsAbleToHand()  
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