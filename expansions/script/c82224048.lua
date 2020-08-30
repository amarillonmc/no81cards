local m=82224048
local cm=_G["c"..m]
cm.name="溪涧虎"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),4,3,cm.ovfilter,aux.Stringid(m,0),4,cm.xyzop)  
	c:EnableReviveLimit()
	--indes  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST))  
	e1:SetValue(1)  
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e2)
	--search  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCondition(cm.thcon) 
	e3:SetCost(cm.thcost) 
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)  
end
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOriginalRank()<4 and c:IsRace(RACE_BEAST)
end 
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end  
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp  
end  
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.thfilter(c)  
	return c:IsRace(RACE_BEAST) and c:IsLevelBelow(4) and c:IsAbleToHand()  
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