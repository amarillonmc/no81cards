--气之精粹
function c1200120.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200120,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1200120.con)
	e1:SetCost(c1200120.cost)
	e1:SetOperation(c1200120.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200120,1))
	e2:SetCountLimit(1,1200120)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1200120.thcost)
	e2:SetTarget(c1200120.thtg)
	e2:SetOperation(c1200120.thop)
	c:RegisterEffect(e2)
end
function c1200120.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c1200120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1200120.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200120,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTarget(c1200120.etarget)
	e1:SetValue(c1200120.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c1200120.etarget(e,c)
	return c:GetControler()==Duel.GetTurnPlayer()
end
function c1200120.efilter(e,re)
	return not re:IsActivated() and re:GetOwner()~=e:GetHandler()
end

function c1200120.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1200120,2))
	local ag=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if ag:GetCount()==1 then
		Duel.SendtoHand(ag,1-tp,REASON_COST)
		Duel.ConfirmCards(tp,ag)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end
function c1200120.thfilter(c)
	return c:IsSetCard(0x3241) and not c:IsCode(1200120) and c:IsAbleToHand()
end
function c1200120.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1200120.thfilter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToHand(1-Duel.GetTurnPlayer()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c1200120.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1200120.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,1-Duel.GetTurnPlayer(),REASON_EFFECT)
		Duel.ConfirmCards(Duel.GetTurnPlayer(),g)
	end
	
	if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(1200120,3)) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	--原定自肃
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	--e1:SetTargetRange(1,0)
	--e1:SetValue(c1200120.aclimit2)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
	
end

function c1200120.aclimit2(e,re,tp)
	return re:GetHandler():IsSetCard(0x3241)
end