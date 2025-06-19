--浩瀚生态的星球改造
function c9911225.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911225+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9911225.cost)
	e1:SetTarget(c9911225.target)
	e1:SetOperation(c9911225.activate)
	c:RegisterEffect(e1)
end
function c9911225.costfilter(c)
	return c:IsSetCard(0x5958) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c9911225.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911225.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9911225.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9911225.thfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsAbleToHand(tp)
end
function c9911225.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	if Duel.IsExistingMatchingCard(c9911225.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) then
		op=Duel.SelectOption(tp,aux.Stringid(9911225,0),aux.Stringid(9911225,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9911225,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(c9911225.activate)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
	else
		e:SetCategory(0)
		e:SetOperation(c9911225.activate2)
	end
end
function c9911225.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911225.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911225.activate2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
