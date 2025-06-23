local m=65809231
local cm=_G["c"..m]
cm.name="策略 禁品交易"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.changecon)
	e2:SetOperation(cm.changeop)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,5) and Duel.GetDecktopGroup(1-tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function cm.getop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>1 then
		local getg=g:RandomSelect(tp,2)
		Duel.SendtoHand(getg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,getg)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.getop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if g:FilterCount(Card.IsAbleToHand,nil,tp)==0 or g:FilterCount(Card.IsAbleToHand,nil,1-tp)==0 then return end
	Duel.ConfirmDecktop(1-tp,5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.RevealSelectDeckSequence(true)
	local tc1=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil,tp):GetFirst()
	local tc2=g:FilterSelect(1-tp,Card.IsAbleToHand,1,1,nil,1-tp):GetFirst()
	Duel.SendtoHand(tc1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc1)
	Duel.SendtoHand(tc2,1-tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,tc2)
	Duel.SortDecktop(tp,1-tp,3)
	for i=1,3 do
		local dg=Duel.GetDecktopGroup(1-tp,1)
		Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
	end
end
function cm.changefilter(c)
	return c:IsCode(m) and c:IsAbleToRemove()
end
function cm.changecon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetFlagEffect(tp,m)<=0 and e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.changefilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function cm.changeop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.repop)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,cm.changefilter,1-tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end