local m=82208103
local cm=_G["c"..m]
cm.name="大仙"
function cm.initial_effect(c)
	--change 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCost(cm.cost1)	
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)  
	e2:SetCost(cm.cost2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetRange(LOCATION_DECK)
	c:RegisterEffect(e3)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end  
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,2,nil) end  
	Duel.ConfirmCards(tp,c)
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,2,2,nil)  
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)   
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--no race  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetTargetRange(0xff,0xff)  
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetCode(EFFECT_CHANGE_RACE)  
	e1:SetValue(0x0)  
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	--all race  
	local e2=e1:Clone() 
	e2:SetValue(0x3ffffff)  
	--no attribute
	local e3=e1:Clone() 
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
	e3:SetValue(0x0)	
	--all attribute
	local e4=e1:Clone() 
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(0x7f) 
	
	local op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if op==0 then
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterEffect(e3,tp)
	else
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterEffect(e4,tp)
	end
end