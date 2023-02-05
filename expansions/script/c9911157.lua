--溯雪啼音·小木曾雪菜
function c9911157.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c9911157.ovfilter,aux.Stringid(9911157,0),2,c9911157.xyzop)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9911157.thcost)
	e1:SetTarget(c9911157.thtg)
	e1:SetOperation(c9911157.thop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9911157,ACTIVITY_CHAIN,c9911157.chainfilter)
end
function c9911157.chainfilter(re,tp,cid)
	return not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9911157.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3958)
end
function c9911157.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9911157)==0
		and Duel.GetCustomActivityCount(9911157,1-tp,ACTIVITY_CHAIN)>0 end
	Duel.RegisterFlagEffect(tp,9911157,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c9911157.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c9911157.ofilter,tp,LOCATION_MZONE,0,1,c)
end
function c9911157.ofilter(c)
	return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c9911157.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911157.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local costg=g:Select(tp,1,1,nil)
	local label=0
	if costg:IsExists(Card.IsSetCard,1,nil,0x3958) then label=1 end
	e:SetLabel(label)
	Duel.SendtoGrave(costg,REASON_COST)
end
function c9911157.thfilter(c)
	return c:IsSetCard(0x3958) and c:IsAbleToHand()
end
function c9911157.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c9911157.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_POSITION)
	end
end
function c9911157.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911157.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9911157,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
