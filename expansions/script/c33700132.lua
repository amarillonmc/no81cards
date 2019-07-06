--浑浊霓酒
function c33700132.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c33700132.target)
	e1:SetOperation(c33700132.activate)
	c:RegisterEffect(e1)
end
function c33700132.filter(c)
	return c:IsFaceup() 
end
function c33700132.cfilter(c,tg)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and tg:GetFirst():GetAttack()>c:GetAttack()
end
function c33700132.target(e,tp,eg,ep,ev,re,r,rp,chk)
	 local g=Duel.GetMatchingGroup(c33700132.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg,atk=g:GetMaxGroup(Card.GetAttack)
	if chk==0 then return tg:GetCount()>0 and Duel.IsExistingMatchingCard(c33700132.cfilter,tp,LOCATION_DECK,0,1,nil,tg) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700132.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700132.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg,atk=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>0 and  Duel.Destroy(tg,REASON_EFFECT)>0 then
	 if  Duel.IsExistingMatchingCard(c33700132.cfilter,tp,LOCATION_DECK,0,1,nil,tg) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 local sg1=Duel.SelectMatchingCard(tp,c33700132.cfilter,tp,LOCATION_DECK,0,1,1,nil,tg)
	if sg1:GetCount()>0 then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	end
   if  Duel.IsExistingMatchingCard(c33700132.cfilter,tp,0,LOCATION_DECK,1,nil,tg) then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 local sg2=Duel.SelectMatchingCard(1-tp,c33700132.cfilter,tp,0,LOCATION_DECK,1,1,nil,tg)
	if sg2:GetCount()>0 then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
	end
end
end
end