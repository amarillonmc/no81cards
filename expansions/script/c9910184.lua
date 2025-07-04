--匪魔的交易
function c9910184.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910184,2))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,9910184)
	e1:SetCondition(c9910184.condition)
	e1:SetCost(c9910184.cost)
	e1:SetTarget(c9910184.target)
	e1:SetOperation(c9910184.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910185)
	e2:SetOperation(c9910184.regop)
	c:RegisterEffect(e2)
end
function c9910184.tgcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK) and c:IsControler(1-tp)
end
function c9910184.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910184.tgcfilter,1,nil,tp)
end
function c9910184.cfilter(c)
	return c:IsSetCard(0x3954) and c:IsFacedown()
end
function c9910184.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910184.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910184.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
end
function c9910184.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c9910184.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910184.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c9910184.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9910184.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910184.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910184.tdfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil):GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910184.thfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local b1=c:IsFaceup() and c:IsSSetable(true)
		local b2=c:IsAbleToDeck() and g:GetCount()>0
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9910184,0),aux.Stringid(9910184,1))==0) then
			Duel.BreakEffect()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		elseif b2 then
			Duel.BreakEffect()
			if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		else
			c:CancelToGrave(false)
		end
	end
end
function c9910184.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c9910184.spop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910184.spfilter(c,e,tp)
	if not (c:IsSetCard(0x3954) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c9910184.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910184)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910184.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
