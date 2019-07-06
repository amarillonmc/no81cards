--霓火豪赌
function c33700135.initial_effect(c)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33700135.target)
	e1:SetOperation(c33700135.operation)
	c:RegisterEffect(e1)
end
function c33700135.filter(c)
	return c:IsSetCard(0x443) and c:IsAbleToHand()
end
function c33700135.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local hd=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then hd=hd-1 end
		return hd>0 and Duel.IsExistingMatchingCard(c33700135.filter,tp,LOCATION_GRAVE,0,1,nil)
	end
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local tg=Duel.GetMatchingGroup(c33700135.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function c33700135.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	local ct=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
	local tg=Duel.GetMatchingGroup(c33700135.filter,tp,LOCATION_GRAVE,0,nil)
	if ct>0 and tg:GetCount()>=ct then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sel=tg:Select(tp,1,ct,nil)
		Duel.SendtoHand(sel,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sel)
	   if sel:GetClassCount(Card.IsCode)~=sel:GetCount() and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(33700135,0)) then
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,tp,0,LOCATION_DECK,1,1,nil)
   Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(tp,g)
end
end
end