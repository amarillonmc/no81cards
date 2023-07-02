--陷入狂暴轮回
function c67200622.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c67200622.handcon)
	c:RegisterEffect(e0) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200622,1))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,67200622+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c67200622.target)
	e3:SetOperation(c67200622.operation)
	c:RegisterEffect(e3)
end
function c67200622.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP)
end
function c67200622.handcon(e)
	return Duel.IsExistingMatchingCard(c67200622.filter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
--
function c67200622.costfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost() 
end
function c67200622.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67200622.costfilter,tp,LOCATION_HAND,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(c67200622.thfilter,tp,LOCATION_GRAVE,0,2,nil)
	local b2=Duel.IsExistingMatchingCard(c67200622.costfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c67200622.costfilter,tp,LOCATION_HAND,0,c)
	local g2=Duel.GetMatchingGroup(c67200622.costfilter,tp,LOCATION_DECK,0,nil)
	if b1 then
		g:Merge(g1)
	end
	if b2 then
		g:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		e:SetLabel(1)
		e:SetCategory(0)
	end
	if tc:IsLocation(LOCATION_DECK) then
		e:SetLabel(2)
		e:SetCategory(0)
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c67200622.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200622.thfilter),tp,LOCATION_GRAVE,0,2,2,nil)
		if #g==2 then
			Duel.SSet(tp,g)
		end
	end
	if label==2 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetCondition(c67200622.thcon)
		e4:SetOperation(c67200622.thop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c67200622.thfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c67200622.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(c67200622.thfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c67200622.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,67200622)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200622.thfilter),tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.SSet(tp,g)
	end
end
