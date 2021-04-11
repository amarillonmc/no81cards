local m=15000067
local cm=_G["c"..m]
cm.name="色带神的崩影"
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(cm.cost) 
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
	Duel.AddCustomActivityCounter(15000067,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)  
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)  
end
function cm.filter1(c,tp)  
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,c,c:GetLeftScale(),c:GetCode())  
end  
function cm.filter2(c,sc,cd)  
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:GetLeftScale()==sc and not c:IsCode(cd)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetCustomActivityCount(15000067,tp,ACTIVITY_SPSUMMON)==0 end  
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)  
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)  
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local tc1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()  
	if not tc1 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local tc2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,tc1,tc1:GetLeftScale(),tc1:GetCode()):GetFirst()  
	Duel.SendtoHand(Group.FromCards(tc1,tc2),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,Group.FromCards(tc1,tc2))  
	Duel.BreakEffect()
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	e1:SetTarget(cm.splimit)  
	e1:SetTargetRange(1,0)  
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end