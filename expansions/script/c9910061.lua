--布琉艾特·妮科莱特·普朗凯特
function c9910061.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910061,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910061)
	e1:SetCondition(c9910061.condition)
	e1:SetCost(c9910061.cost)
	e1:SetTarget(c9910061.target)
	e1:SetOperation(c9910061.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c9910061.thregop)
	c:RegisterEffect(e2)
end
function c9910061.condition(e,tp,eg,ep,ev,re,r,rp)
	local rec=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rec:IsSummonType(SUMMON_TYPE_SPECIAL)
		and ((rec:IsOnField() and rec:GetControler()~=tp) or (not rec:IsOnField() and rec:GetPreviousControler()~=tp))
end
function c9910061.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910061.rmfilter(c)
	return (c:IsCode(9910052) or c:IsCode(9910063)) and c:IsAbleToRemove()
end
function c9910061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910061.rmfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9910061.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910061.rmfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT)<=0 then return end
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910061.drcon1)
	e1:SetOperation(c9910061.drop1)
	e1:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9910061.regcon)
	e2:SetOperation(c9910061.regop)
	e2:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c9910061.drcon2)
	e3:SetOperation(c9910061.drop2)
	e3:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e3,tp)
end
function c9910061.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c9910061.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910061.filter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c9910061.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c9910061.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910061.filter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c9910061.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,9910061,RESET_CHAIN,0,1)
end
function c9910061.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9910061)>0
end
function c9910061.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,9910061)
	Duel.ResetFlagEffect(tp,9910061)
	Duel.Draw(tp,n,REASON_EFFECT)
end
function c9910061.thregop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910061,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,9910062)
	e1:SetCost(c9910061.thcost)
	e1:SetTarget(c9910061.thtg)
	e1:SetOperation(c9910061.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c9910061.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToDeckAsCost()
end
function c9910061.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910061.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910061.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c9910061.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9910061.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
