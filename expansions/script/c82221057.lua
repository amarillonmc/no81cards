function c82221057.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221057,0))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,82221057)  
	e2:SetCost(c82221057.thcost)  
	e2:SetTarget(c82221057.thtg)  
	e2:SetOperation(c82221057.thop)  
	c:RegisterEffect(e2) 
	--damage  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e3:SetOperation(c82221057.regop)  
	c:RegisterEffect(e3)  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetCode(EVENT_CHAIN_SOLVED)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCondition(c82221057.damcon)  
	e4:SetOperation(c82221057.damop)  
	c:RegisterEffect(e4)  
end  
function c82221057.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c82221057.costfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,2,nil) end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	e1:SetTargetRange(1,0)  
	Duel.RegisterEffect(e1,tp)  
	local g=Duel.SelectMatchingCard(tp,c82221057.costfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end 
function c82221057.costfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end   
function c82221057.thfilter(c)  
	return c:GetType()==TYPE_SPELL and c:IsAbleToHand()
end  
function c82221057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221057.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221057.thop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221057.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)   
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function c82221057.regop(e,tp,eg,ep,ev,re,r,rp)  
	if rp~=tp or not (re:IsActiveType(TYPE_SPELL) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_PENDULUM)) then return end  
	e:GetHandler():RegisterFlagEffect(82221057,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)  
end  
function c82221057.damcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return ep==tp and c:GetFlagEffect(82221057)~=0 and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_PENDULUM)
end  
function c82221057.damop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,82221057)  
	Duel.Damage(1-tp,300,REASON_EFFECT)  
end  