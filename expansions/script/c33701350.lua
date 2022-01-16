--动物朋友 驴
function c33701350.initial_effect(c)
	--check deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701350,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33701350.thcost)
	e1:SetTarget(c33701350.thtg)
	e1:SetOperation(c33701350.thop)
	c:RegisterEffect(e1)  
	--deck check 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701350,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c33701350.target)
	e2:SetOperation(c33701350.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c33701350.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33701350.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c33701350.thfilter(c)
	return c:IsSetCard(0x442) and c:IsAbleToHand()
end
function c33701350.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	local sg=g:Filter(c33701350.thfilter,nil)
	if sg:GetCount()>0 and c:IsRelateToEffect(e) and c:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(33701350,1)) then
		Duel.DisableShuffleCheck()
		if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
			local sg=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.BreakEffect()
			local g1=Duel.GetDecktopGroup(tp,3)
			Duel.ConfirmCards(tp,g1)
			Duel.SortDecktop(tp,tp,3)
		end
	end
end
function c33701350.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c33701350.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	local num=g:FilterCount(Card.IsSetCard,nil,0x442)
	if num>0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
	if num>1 then
		Duel.Recover(tp,2000,REASON_EFFECT)
	end
	if num>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,c33701350.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end