--精灵之镜的呼唤
function c21474353.initial_effect(c)
	aux.AddCodeList(c,35563539)
	aux.AddCodeList(c,40383551)
	aux.AddCodeList(c,93946239)
	aux.AddCodeList(c,70278545)
	aux.AddCodeList(c,56119752)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21474353.target)
	e1:SetOperation(c21474353.activate)
	c:RegisterEffect(e1)
end
function c21474353.filter(c)
	return (aux.IsCodeListed(c,40383551) or aux.IsCodeListed(c,35563539) or aux.IsCodeListed(c,93946239) or aux.IsCodeListed(c,70278545) or aux.IsCodeListed(c,56119752)) and not c:IsCode(21474353)  and c:IsAbleToHand()
end
function c21474353.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21474353.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21474353.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21474353.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

