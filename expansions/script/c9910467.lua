--宛若韶光永驻
function c9910467.initial_effect(c)
	aux.AddCodeList(c,9910467)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910467+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910467.target)
	e1:SetOperation(c9910467.activate)
	c:RegisterEffect(e1)
	--double recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(9910467)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c9910467.condition)
	c:RegisterEffect(e2)
end
function c9910467.filter(c)
	return c:IsSetCard(0x9950) and c:IsAbleToHand() and not c:IsCode(9910467)
end
function c9910467.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910467.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910467.cfilter(c)
	return c:IsSetCard(0x9950) and not c:IsPublic()
end
function c9910467.ctfilter(c)
	return c:IsSetCard(0x9950) and c:IsCanAddCounter(0x1950,1)
end
function c9910467.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c9910467.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()==0 or Duel.SendtoHand(g1,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g1)
	local g2=Duel.GetMatchingGroup(c9910467.cfilter,tp,LOCATION_HAND,0,nil)
	local g3=Duel.GetMatchingGroup(c9910467.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if g2:GetCount()==0 or g3:GetCount()==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(9910467,0)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g2:Select(tp,1,99,nil)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	local ct=cg:GetCount()
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g3:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1950,1)
	end
end
function c9910467.cfilter2(c)
	return c:GetCounter(0x1950)>0
end
function c9910467.condition(e)
	return Duel.IsExistingMatchingCard(c9910467.cfilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,5,nil)
end
