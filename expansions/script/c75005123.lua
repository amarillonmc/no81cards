--希翠丝的叫醒服务
function c75005123.initial_effect(c)
	--TT
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCondition(c75005123.ttcon)
	e1:SetCost(c75005123.ttcost)
	e1:SetOperation(c75005123.ttop)
	c:RegisterEffect(e1)
end
function c75005123.ttcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c75005123.ttcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	e:SetLabel(bit.band(re:GetHandler():GetType(),0x7))
end
function c75005123.ttop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(e:GetLabel())
	e1:SetOperation(c75005123.operation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75005123.tgfilter(c,type)
	return bit.band(c:GetType(),type)~=0 and c:IsAbleToGrave()
end
function c75005123.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75005123)
	local type=e:GetLabel()
	if Duel.IsExistingMatchingCard(c75005123.tgfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil,type) and Duel.SelectYesNo(tp,aux.Stringid(75005123,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c75005123.tgfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil,type)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		Duel.SetLP(tp,Duel.GetLP(tp)-2000)
		local b1=Duel.IsPlayerCanDraw(tp,2)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
		local b3=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		if not (b1 or b2 or b3) then return end
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(75005123,1)},
			{b2,aux.Stringid(75005123,2)},
			{b3,aux.Stringid(75005123,3)})
		Debug.Message("饿啊")
		if op==1 then
			Duel.Draw(tp,2,REASON_EFFECT)
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		elseif op==3 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Duel.ConfirmCards(tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	end
end
