--术结天缘 残光相依
function c67200426.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200426+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67200426.cost)
	e1:SetTarget(c67200426.target)
	e1:SetOperation(c67200426.activate)
	c:RegisterEffect(e1)  
end
--

function c67200426.excostfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c67200426.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c67200426.thfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHand()
end
function c67200426.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetFieldGroup(c67200426.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c67200426.excostfilter,tp,LOCATION_ONFIELD,0,1,c) and rt:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200426.excostfilter,tp,LOCATION_ONFIELD,0,1,rt:GetCount(),c)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,rt,g:GetCount(),tp,LOCATION_DECK)
	e:SetLabel(g:GetCount())
end
function c67200426.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	local gg=Duel.GetFieldGroup(c67200426.thfilter,tp,LOCATION_DECK,0,nil)
	if gg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c67200426.thfilter,tp,LOCATION_DECK,0,1,label,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

