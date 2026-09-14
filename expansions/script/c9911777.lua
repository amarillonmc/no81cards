--死者行军-八房
function c9911777.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911777.cost)
	e1:SetTarget(c9911777.target)
	e1:SetOperation(c9911777.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c9911777.regop)
	c:RegisterEffect(e2)
end
function c9911777.cfilter(c)
	return c:IsCode(9911776) and (not c:IsPublic() or c:IsLocation(LOCATION_DECK))
end
function c9911777.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local opt1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
	local opt2=Duel.IsExistingMatchingCard(c9911777.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,3,e:GetHandler())
	if chk==0 then return opt1 or opt2 end
	local result=0
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(9911777,0),aux.Stringid(9911777,1)) end
	if result==0 then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c9911777.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,3,3,nil)
		Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(tp) end
	end
end
function c9911777.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9911777.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if Duel.Destroy(tc,REASON_EFFECT)>0 and aux.NecroValleyFilter()(tc)
			and not (tc:IsLocation(LOCATION_HAND+LOCATION_DECK) or tc:IsLocation(LOCATION_REMOVED) and tc:IsFacedown()) then
			if tc:IsType(TYPE_MONSTER) and (not tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or tc:IsLocation(LOCATION_EXTRA) and tc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0)
				and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(9911777,2)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(9911777,3)) then
				Duel.BreakEffect()
				Duel.SSet(tp,tc)
			end
		end
	end
end
function c9911777.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(c9911777.thcon)
	e1:SetOperation(c9911777.thop)
	Duel.RegisterEffect(e1,tp)
end
function c9911777.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c9911777.thfilter(c)
	return c:IsCode(9911776) and c:IsAbleToHand()
end
function c9911777.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911777)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911777.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
