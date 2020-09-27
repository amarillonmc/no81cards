--Fruitless de Lapin
function c500006.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500006,4))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--Activate2
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(500006,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetCountLimit(1,500006)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetCost(c500006.thcost)
	e0:SetCondition(c500006.thcon)
	e0:SetTarget(c500006.thtg)
	e0:SetOperation(c500006.thop)
	c:RegisterEffect(e0) 
	--sssss
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500006,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,500006)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c500006.thcost)
	e2:SetCondition(c500006.thcon)
	e2:SetTarget(c500006.thtg)
	e2:SetOperation(c500006.thop)
	c:RegisterEffect(e2)
	--set
	local ex2=Effect.CreateEffect(c)
	ex2:SetDescription(aux.Stringid(500005,1))
	ex2:SetType(EFFECT_TYPE_QUICK_O)
	ex2:SetHintTiming(0,TIMING_END_PHASE)
	ex2:SetCode(EVENT_FREE_CHAIN)
	ex2:SetCountLimit(1,500006)
	ex2:SetRange(LOCATION_SZONE)
	ex2:SetCost(c500006.scost)
	ex2:SetTarget(c500006.stg)
	ex2:SetOperation(c500006.sop)
	c:RegisterEffect(ex2)
	--sssss
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(500006,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,500106)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCost(c500006.scost2)
	e3:SetTarget(c500006.stg2)
	e3:SetOperation(c500006.sop2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(500006,ACTIVITY_CHAIN,c500006.chainfilter)
c500006.noway=true
end
function c500006.confilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp
end
function c500006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500006.confilter,1,nil,1-tp)
end
function c500006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c500006.confilter,nil,1-tp):Filter(Card.IsAbleToDeck,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount()>0,1-tp,0)
end
function c500006.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
	   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c500006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(500006,tp,ACTIVITY_CHAIN)==0 end
	if Duel.GetTurnPlayer()~=tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c500006.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c500006.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_MZONE 
end
function c500006.setfilter3(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad))
end
function c500006.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500006.setfilter3,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c500006.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500006.setfilter3,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c500006.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c500006.cfilter(c,tp,rc)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and c:IsAbleToDeckAsCost() and c:IsFaceup() and Duel.IsExistingMatchingCard(c500006.setfilter2,tp,LOCATION_GRAVE,0,1,c,rc,tp) and not c:IsCode(500008)
end
function c500006.setfilter2(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable() and (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and not c:IsCode(500008)
end
function c500006.scost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c500006.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c500006.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c500006.stg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500006.setfilter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function c500006.sop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500006.setfilter2,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c500006.chainfilter(re,tp,cid)
	return re:GetActivateLocation()~=LOCATION_MZONE 
end