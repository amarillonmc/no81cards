--XDelivery
function c33741087.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33741087.target)
	e1:SetOperation(c33741087.activate)
	c:RegisterEffect(e1)
end
function c33741087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=10 end
end
function c33741087.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<10 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:Select(tp,10,#g,nil)
	if #cg==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local ct=0
	if Duel.SelectYesNo(tp,aux.Stringid(33741087,2)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=cg:FilterSelect(1-tp,Card.IsAbleToHand,1,#cg,nil,1-tp)
		cg:Sub(tg)
		ct=Duel.SendtoHand(tg,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	Duel.SendtoDeck(cg,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
