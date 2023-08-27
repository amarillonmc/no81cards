--炭酸装姬整备
function c11526302.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11526302+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11526302.cost)
	e1:SetTarget(c11526302.target)
	e1:SetOperation(c11526302.activate)
	c:RegisterEffect(e1)   
end
c11526302.SetCard_Carbonic_Acid_Girl=true 
--
function c11526302.costfilter(c)
	local tp=c:GetControler()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c.SetCard_Carbonic_Acid_Girl
		and Duel.IsExistingMatchingCard(c11526302.filter,tp,LOCATION_DECK,0,1,nil)
end
function c11526302.filter(c)
	return c:IsType(TYPE_MONSTER) and c.SetCard_Carbonic_Acid_Girl and c:IsAbleToHand()
end
function c11526302.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c11526302.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c11526302.costfilter,tp,LOCATION_DECK,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(c11526302.filter,tp,LOCATION_DECK,0,1,nil)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c11526302.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SendtoGrave(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11526302.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11526302.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end