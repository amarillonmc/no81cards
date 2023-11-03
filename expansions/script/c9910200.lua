--炼金研究员6048
function c9910200.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910200,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9910200.thcost)
	e1:SetTarget(c9910200.thtg)
	e1:SetOperation(c9910200.thop)
	c:RegisterEffect(e1)
	--position/return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910200,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9910200.setcost)
	e2:SetTarget(c9910200.settg)
	e2:SetOperation(c9910200.setop)
	c:RegisterEffect(e2)
end
function c9910200.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910200.thfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsAbleToHand() and not c:IsCode(9910200)
end
function c9910200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910200.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910200.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910200.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910200.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9910200.costfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function c9910200.filter(c,mg)
	if c:IsFacedown() or (not c:IsCanTurnSet() and not c:IsAbleToHand()) then return false end
	if not mg then return true end
	local ct=1
	if not c:IsCanTurnSet() then ct=2 end
	return mg:CheckSubGroup(aux.drccheck,ct,ct)
end
function c9910200.filter1(c,e)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsCanBeEffectTarget(e)
end
function c9910200.filter2(c,e)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c9910200.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=Duel.GetMatchingGroup(c9910200.costfilter,tp,LOCATION_HAND,0,nil)
	local g1=Duel.GetMatchingGroup(c9910200.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local g2=Duel.GetMatchingGroup(c9910200.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local min=1
	local max=2
	if #g1==0 then min=2 end
	if #g2==0 then max=1 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and (c9910200.filter1(chkc,e) or c9910200.filter2(chkc,e)) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return min<=max and cg:CheckSubGroup(aux.drccheck,min,max)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=cg:SelectSubGroup(tp,aux.drccheck,false,min,max)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	e:SetLabel(#sg)
	if #sg==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c9910200.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c9910200.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	end
end
function c9910200.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if ct==1 and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
	if ct==2 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
