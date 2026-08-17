--默墟天使·时之轮回
function c43990997.initial_effect(c)
	aux.AddCodeList(c,43990999)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990997.target)
	e1:SetOperation(c43990997.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990997,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c43990997.tdcon)
	e2:SetCost(c43990997.tdcost)
	e2:SetTarget(c43990997.tdtg)
	e2:SetOperation(c43990997.tdop)
	c:RegisterEffect(e2)
end
function c43990997.tgfilter(c)
	return c:IsSetCard(0x9510) and c:IsFaceupEx() and c:IsAbleToGrave()
end
function c43990997.cfilter(c)
	return c:IsCode(43990999) and c:IsFaceup()
end
function c43990997.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c43990997.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) and (Duel.GetFlagEffect(tp,43990997)==0 or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(c43990997.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,e:GetHandler()) and (Duel.GetFlagEffect(tp,43990997-10)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990997,0)},
		{b2,aux.Stringid(43990997,1)})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
			Duel.RegisterFlagEffect(tp,43990997,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TODECK)
			Duel.RegisterFlagEffect(tp,43990997-10,RESET_PHASE+PHASE_END,0,1)
		end
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
	--
	if e:IsCostChecked() then
		local ct=Duel.GetFlagEffectLabel(tp,43990997) or 0
		ct=ct|op
		if ct==op then
			Duel.RegisterFlagEffect(tp,43990997,RESET_PHASE+PHASE_END,0,1,ct)
		else
			Duel.SetFlagEffectLabel(tp,43990997,ct)
		end
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+43990999,e,0,tp,0,0)
	end
end
function c43990997.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,c43990997.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler()):GetFirst()
		if not tc then return end
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil)
		if #tg==0 then return end
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c43990997.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x9510) and re:IsActiveType(TYPE_MONSTER)
end
function c43990997.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990997.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,e:GetHandler()) end
end
function c43990997.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
