--梅丽尔·琳琪
function c9910063.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910063,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CUSTOM+9910063)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910063)
	e1:SetCondition(c9910063.condition)
	e1:SetCost(c9910063.cost)
	e1:SetTarget(c9910063.target)
	e1:SetOperation(c9910063.operation)
	c:RegisterEffect(e1)
	if not c9910063.global_check then
		c9910063.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c9910063.regcon)
		ge1:SetOperation(c9910063.regop)
		Duel.RegisterEffect(ge1,0)
	end
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c9910063.thregop)
	c:RegisterEffect(e2)
end
function c9910063.checkfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c9910063.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	local v=0
	if eg:IsExists(c9910063.checkfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c9910063.checkfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c9910063.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+9910063,re,r,rp,ep,e:GetLabel())
end
function c9910063.condition(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==PLAYER_ALL
end
function c9910063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910063.rmfilter(c)
	return (c:IsCode(9910052) or c:IsCode(9910061)) and c:IsAbleToRemove()
end
function c9910063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910063.rmfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9910063.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910063.rmfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT)<=0 then return end
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c9910063.dccon1)
	e1:SetOperation(c9910063.dcop1)
	e1:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c9910063.dcregcon)
	e2:SetOperation(c9910063.dcregop)
	e2:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c9910063.dccon2)
	e3:SetOperation(c9910063.dcop2)
	e3:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e3,tp)
end
function c9910063.filter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c9910063.dccon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910063.filter,1,nil,1-tp)
		and rp==1-tp and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c9910063.dcop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
function c9910063.dcregcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910063.filter,1,nil,1-tp)
		and rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c9910063.dcregop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,9910064,RESET_CHAIN,0,1)
end
function c9910063.dccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9910064)>0
end
function c9910063.dcop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,9910064)
	Duel.ResetFlagEffect(tp,9910064)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>=n then
		local sg=g:RandomSelect(1-tp,n)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
function c9910063.thregop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910063,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,9910064)
	e1:SetCost(c9910063.thcost)
	e1:SetTarget(c9910063.thtg)
	e1:SetOperation(c9910063.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c9910063.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToDeckAsCost()
end
function c9910063.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910063.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910063.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c9910063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9910063.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
