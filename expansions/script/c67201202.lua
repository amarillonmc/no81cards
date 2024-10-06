--狂暴轮回看破
function c67201202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,67201202+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c67201202.condition)
	e1:SetTarget(c67201202.target)
	e1:SetOperation(c67201202.operation)
	c:RegisterEffect(e1) 
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201202,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c67201202.tdtg)
	e2:SetOperation(c67201202.tdop)
	c:RegisterEffect(e2)   
end
function c67201202.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c67201202.costfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHandAsCost() and c:IsFaceupEx()
end
function c67201202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67201202.costfilter,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsChainNegatable(ev)
	local b2=Duel.IsExistingMatchingCard(c67201202.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c67201202.costfilter,tp,LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(c67201202.costfilter,tp,LOCATION_GRAVE,0,nil)
	if b1 then
		g:Merge(g1)
	end
	if b2 then
		g:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_ONFIELD) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	end
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetLabel(2)
		e:SetCategory(0)
	end
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c67201202.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
	if label==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(67201202,5))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c67201202.disop)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67201202.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ep==tp then return end
	if Duel.GetFlagEffect(tp,67201202)==0 and Duel.SelectYesNo(tp,aux.Stringid(67201202,3)) then
		Duel.RegisterFlagEffect(tp,67201202,RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev,true)
	end
end
--
function c67201202.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,c)
	if chk==0 then return c:IsAbleToDeck() and g:GetCount()>0 end
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c67201202.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,c)
		if g:GetCount()>0 then
			g:AddCard(c)
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
