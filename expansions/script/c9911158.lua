--溯雪心弦·北原春希
function c9911158.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c9911158.ovfilter,aux.Stringid(9911158,0),2,c9911158.xyzop)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9911158.thcost)
	e1:SetTarget(c9911158.thtg)
	e1:SetOperation(c9911158.thop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9911158,ACTIVITY_CHAIN,c9911158.chainfilter)
end
function c9911158.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE)
end
function c9911158.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3958)
end
function c9911158.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9911158)==0
		and Duel.GetCustomActivityCount(9911158,1-tp,ACTIVITY_CHAIN)>0 end
	Duel.RegisterFlagEffect(tp,9911158,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c9911158.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c9911158.ofilter,tp,LOCATION_MZONE,0,1,c)
end
function c9911158.ofilter(c)
	return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c9911158.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911158.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local costg=g:Select(tp,1,1,nil)
	local label=0
	if costg:IsExists(Card.IsSetCard,1,nil,0x3958) then label=1 end
	e:SetLabel(label)
	Duel.SendtoGrave(costg,REASON_COST)
end
function c9911158.thfilter(c)
	return c:IsSetCard(0x3958) and c:IsAbleToHand()
end
function c9911158.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c9911158.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_DISABLE)
	end
end
function c9911158.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911158.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if e:GetLabel()==1 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(9911158,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	end
end
