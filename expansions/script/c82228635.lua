local m=82228635
local cm=_G["c"..m]
cm.name="DD 纤维"
function cm.initial_effect(c)
	--to hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCountLimit(1,m)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2)  
end
function cm.thfilter(c)  
	return c:IsSetCard(0xaf) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) 
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local dg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
		return dg:GetClassCount(Card.GetCode)>=2
	end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetClassCount(Card.GetCode)>=2 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)  
		local sg1=g:Select(tp,1,1,nil)  
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)  
		local sg2=g:Select(tp,1,1,nil)  
		sg1:Merge(sg2)
		Duel.ConfirmCards(1-tp,sg1)  
		Duel.ShuffleDeck(tp)  
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)  
		local cg=sg1:Select(1-tp,1,1,nil)  
		local tc=cg:GetFirst()  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
		sg1:RemoveCard(tc)  
		Duel.SendtoGrave(sg1,REASON_EFFECT)  
	end  
end  