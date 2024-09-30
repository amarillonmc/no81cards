--闪耀的中心
function c28335405.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28335405.target)
	e1:SetOperation(c28335405.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,28335405)
	e2:SetCost(c28335405.thcost)
	e2:SetTarget(c28335405.thtg)
	e2:SetOperation(c28335405.thop)
	c:RegisterEffect(e2)
end
function c28335405.center(c)
	return aux.IsCodeListed(c,28335405) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28335405.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28335405.center,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28335405.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToGrave()
end
function c28335405.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28335405.center,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc:GetCount()>0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsCode(28315548) and Duel.IsExistingMatchingCard(c28335405.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28335405,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,c28335405.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
function c28335405.thfilter(c)
	return c:GetSequence()==2 and aux.IsCodeListed(c,28335405) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c28335405.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28335405.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c28335405.thfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c28335405.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
end
function c28335405.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)  
	end
end
