--遍历权能·诗寇蒂
function c67200844.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200844,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200845)
	e1:SetCondition(c67200844.thcon)
	e1:SetTarget(c67200844.thtg)
	e1:SetOperation(c67200844.thop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,67200844)
	e2:SetCondition(c67200844.condition)
	e2:SetCost(c67200844.cost)
	e2:SetTarget(c67200844.target)
	e2:SetOperation(c67200844.activate)
	c:RegisterEffect(e2)	
end
function c67200844.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp 
end
function c67200844.thfilter(c)
	return c:IsCode(67200846) and c:IsAbleToHand()
end
function c67200844.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200844.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200844.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c67200844.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--
function c67200844.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_DRAW)
end
function c67200844.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c67200844.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200844.cfilter,1,nil,1-tp) and rp==1-tp
end
function c67200844.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsAbleToDeck,eg:GetCount(),nil) and Duel.IsPlayerCanDraw(tp,eg:GetCount()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67200844.tdfilter(c)
	return not c:IsLocation(LOCATION_HAND)
end
function c67200844.activate(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c67200844.tdfilter,1,nil) then return end
	if Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local egg=Duel.GetOperatedGroup()
		Duel.Draw(1-tp,egg:GetCount(),REASON_EFFECT)
	end
end

