--散华
function c11561016.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11561016)
	e1:SetCost(c11561016.cost)
	e1:SetOperation(c11561016.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(11561016,ACTIVITY_CHAIN,aux.FALSE)
end
function c11561016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c11561016.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c11561016.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11561016.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCustomActivityCount(11561016,1-tp,ACTIVITY_CHAIN)
	if ct==0 then return end
	Duel.Hint(HINT_CARD,0,11561016)
	if ct>Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) then ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmCards(tp,g)
	local cg=g:Filter(Card.IsAbleToHand,nil)
	if cg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=cg:SelectSubGroup(tp,aux.TRUE,true,0,math.floor(#g/4))
	if tg:GetCount()>0 then
		g:Sub(tg)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,#tg,#tg,nil)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
			g:Merge(sg)
			Duel.SortDecktop(tp,tp,ct)
			if #sg>=math.ceil(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)/2) and Duel.IsPlayerCanDraw(tp,1) then
				Duel.ShuffleHand(tp)
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
