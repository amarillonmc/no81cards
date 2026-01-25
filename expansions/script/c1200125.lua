--酒之精粹
function c1200125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200125,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c1200125.operation)
	c:RegisterEffect(e1)
	--to hand 原定2效果
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(1200125,1))
	--e2:SetCountLimit(1,1200125)
	--e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e2:SetType(EFFECT_TYPE_QUICK_O)
	--e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetRange(LOCATION_GRAVE)
	--e2:SetCost(c1200125.thcost)
	--e2:SetTarget(c1200125.thtg)
	--e2:SetOperation(c1200125.thop)
	--c:RegisterEffect(e2)
end

function c1200125.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200125,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c1200125.con)
	e1:SetOperation(c1200125.op)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200125,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(aux.FALSE)
	e2:SetValue(aux.FALSE)
	Duel.RegisterEffect(e2,tp)
end
function c1200125.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==Duel.GetTurnPlayer()
end
function c1200125.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c1200125.repop)
end
function c1200125.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1200125)
	local c=e:GetHandler()
	--if c:IsRelateToEffect(e) then
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT,tp,true)
	--end
end

function c1200125.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1200125,2))
	local ag=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if ag:GetCount()==1 then
		Duel.SendtoHand(ag,1-tp,REASON_COST)
		Duel.ConfirmCards(tp,ag)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end
function c1200125.thfilter(c)
	return c:IsSetCard(0x211) and not c:IsCode(1200125) and c:IsAbleToHand()
end
function c1200125.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1200125.thfilter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToHand(1-Duel.GetTurnPlayer()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c1200125.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1200125.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,1-Duel.GetTurnPlayer(),REASON_EFFECT)
		Duel.ConfirmCards(Duel.GetTurnPlayer(),g)
	end
	
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end