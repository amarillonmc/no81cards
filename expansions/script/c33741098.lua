--Sparkling, Miracle Star
function c33741098.initial_effect(c)
	--code
	aux.EnableChangeCode(c,33700055,LOCATION_GRAVE)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)--
	e1:SetDescription(aux.Stringid(33741098,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,33741098)
	e1:SetCost(c33741098.cost)
	e1:SetTarget(c33741098.target)
	e1:SetOperation(c33741098.operation)
	c:RegisterEffect(e1)
end
function c33741098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c33741098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_EXTRA,0)>0 end
end
function c33741098.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
	if #g==0 then return end
	Duel.ConfirmCards(1-tp,g)
	if g:GetClassCount(Card.GetCode)~=#g or not Duel.SelectYesNo(tp,aux.Stringid(33741098,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	--
	local p=1-tp
	local b1=tc:IsAbleToHand()
	local b2=tc:IsAbleToHand(p)
	local b3=not tc:IsForbidden() and (tc:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp)>0 or not tc:IsType(TYPE_MONSTER) and Duel.GetSZoneCount(tp)>0 or tc:IsType(TYPE_FIELD))
	if not (b1 or b2 or b3) then return end
	local op=aux.SelectFromOptions(p,
		{b1,aux.Stringid(33741098,1)},
		{b2,aux.Stringid(33741098,2)},
		{b3,aux.Stringid(33741098,3)})
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(p,tc)
	elseif op==2 then
		Duel.SendtoHand(tc,p,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e2)
		if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(33741098,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_DECK,1,1,nil,tp):GetFirst()
			Duel.SendtoHand(sc,tp,REASON_EFFECT)
			Duel.ConfirmCards(p,sc)
			local e3=e1:Clone()
			sc:RegisterEffect(e3)
			local e4=e2:Clone()
			sc:RegisterEffect(e4)
		end
	elseif op==3 then
		local loc=tc:IsType(TYPE_MONSTER) and LOCATION_MZONE or LOCATION_SZONE 
		if tc:IsType(TYPE_FIELD) then
			loc=LOCATION_FZONE
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
		end
		local pos=tc:IsType(TYPE_MONSTER) and POS_FACEDOWN_DEFENSE or POS_FACEDOWN 
		Duel.MoveToField(tc,tp,tp,loc,pos,true)
	end
end
