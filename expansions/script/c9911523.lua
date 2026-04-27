--觅迹人荒芜探索
function c9911523.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911523)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911523.cost)
	e1:SetTarget(c9911523.target)
	e1:SetOperation(c9911523.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9911524)
	e3:SetTarget(c9911523.thtg)
	e3:SetOperation(c9911523.thop)
	c:RegisterEffect(e3)
end
function c9911523.cfilter(c,tp)
	local b1=not c:IsSetCard(0x5952)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1 and Duel.IsPlayerCanDraw(tp,1)
	return c:IsDiscardable() and (b1 or b2)
end
function c9911523.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911523.cfilter,tp,LOCATION_HAND,0,e:GetHandler(),tp)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=g:Select(tp,1,1,nil)
	local label=0
	if dg:IsExists(Card.IsSetCard,1,nil,0x5952) then label=1 end
	e:SetLabel(label)
	Duel.SendtoGrave(dg,REASON_COST+REASON_DISCARD)
end
function c9911523.filter(c)
	return c:IsSetCard(0x5952) and c:IsAbleToHand() and not c:IsCode(9911523)
end
function c9911523.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911523.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DRAW)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c9911523.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911523.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()==1 and #tg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=tg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.HintSelection(sg)
			local res=0
			local tc=sg:GetFirst()
			if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
				res=Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
			else
				local opt=Duel.SelectOption(tp,aux.Stringid(9911523,0),aux.Stringid(9911523,1))
				if opt==0 then
					res=Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
				else
					res=Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				end
			end
			if res>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then Duel.Draw(tp,1,REASON_EFFECT) end
		end
	end
end
function c9911523.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
		and chkc:IsAbleToHand() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=aux.SelectTargetFromFieldFirst(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9911523.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
