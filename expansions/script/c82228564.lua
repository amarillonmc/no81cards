local m=82228564
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con1) 
	e2:SetTarget(cm.tg)  
	e2:SetOperation(cm.op) 
	e2:SetCost(cm.cost2) 
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(cm.con2)
	e3:SetCost(cm.cost)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)  
	return c:IsCode(82228562)  
end  
function cm.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)  
end 
function cm.con1(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsPlayerAffectedByEffect(tp,82228569)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp) 
	return not Duel.IsPlayerAffectedByEffect(tp,82228569)
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end 
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end  
function cm.filter(c)  
	return ((c:IsSetCard(0x297) and not c:IsCode(m) and not c:IsType(TYPE_MONSTER)) or c:IsCode(22702055)) and c:IsAbleToHand()  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  