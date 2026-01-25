--水之精粹
function c1200110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200105,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e1:SetOperation(c1200110.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200110,0))
	e2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,0)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c1200110.handcon)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200110,1))
	e3:SetCountLimit(1,1200110)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c1200110.thcost)
	e3:SetTarget(c1200110.thtg)
	e3:SetOperation(c1200110.thop)
	c:RegisterEffect(e3)
end
function c1200110.actfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c1200110.handcon(e)
	return not Duel.IsExistingMatchingCard(c1200110.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c1200110.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200110,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c1200110.aclimit)
	Duel.RegisterEffect(e1,tp)
end
function c1200110.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	if tp==Duel.GetTurnPlayer() then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE)
end

function c1200110.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1200110,2))
	local ag=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if ag:GetCount()==1 then
		Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,ag)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end
function c1200110.thfilter(c)
	return c:IsSetCard(0x3241) and not c:IsCode(1200110) and c:IsAbleToHand()
end
function c1200110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1200110.thfilter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToHand(1-Duel.GetTurnPlayer()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c1200110.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1200110.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,1-Duel.GetTurnPlayer(),REASON_EFFECT)
		Duel.ConfirmCards(Duel.GetTurnPlayer(),g)
	end
	
	if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(1200110,3)) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	--原定自肃
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	--e1:SetTargetRange(1,0)
	--e1:SetValue(c1200110.aclimit2)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
	
end
function c1200110.aclimit2(e,re,tp)
	return re:GetHandler():IsSetCard(0x3241)
end