--天空漫步者-空返踢
function c9910214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910214.condition)
	e1:SetTarget(c9910214.target)
	e1:SetOperation(c9910214.activate)
	c:RegisterEffect(e1)
	--recycle & remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910214)
	e2:SetCost(c9910214.thcost)
	e2:SetTarget(c9910214.thtg)
	e2:SetOperation(c9910214.thop)
	c:RegisterEffect(e2)
end
function c9910214.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910214.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910214.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910214.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910214.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910214.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
end
function c9910214.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910214.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0
		and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(9910214,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			if Duel.Destroy(sg,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
				c:CancelToGrave()
				Duel.SendtoHand(c,nil,REASON_EFFECT)
			end
		end
	end
end
function c9910214.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(c))
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9910214.rmfilter(c)
	return c:IsSetCard(0x6956) and c:IsAbleToGrave()
end
function c9910214.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910214.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c9910214.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
	e:SetLabelObject(g2:GetFirst())
end
function c9910214.thop(e,tp,eg,ep,ev,re,r,rp)
   local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsRelateToEffect(e) and Duel.SendtoHand(tc1,nil,REASON_EFFECT)>0
		and tc1:IsLocation(LOCATION_HAND) and tc2:IsRelateToEffect(e) then
		Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
	end
end
