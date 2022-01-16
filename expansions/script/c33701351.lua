--动物朋友 亚洲斑嘴鸭
function c33701351.initial_effect(c)
   --check deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701351,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33701351.thcost)
	e1:SetTarget(c33701351.thtg)
	e1:SetOperation(c33701351.thop)
	c:RegisterEffect(e1)  
	--deck check 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701351,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c33701351.target)
	e2:SetOperation(c33701351.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c33701351.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33701351.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c33701351.thfilter(c)
	return c:IsSetCard(0x442) and c:IsAbleToHand()
end
function c33701351.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	local sg=g:Filter(c33701351.thfilter,nil)
	if sg:GetCount()>0 and c:IsRelateToEffect(e) and c:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(33701351,1)) then
		Duel.DisableShuffleCheck()
		if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.BreakEffect()
			local g1=Duel.GetDecktopGroup(tp,3)
			Duel.ConfirmCards(tp,g1)
			Duel.SortDecktop(tp,tp,3)
		end
	end
end
function c33701351.adfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x442)
end
function c33701351.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c33701351.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local num=g:FilterCount(Card.IsSetCard,nil,0x442)
	local sg=Duel.GetMatchingGroup(c33701351.adfilter,tp,LOCATION_MZONE,0,nil)
	if num>0 then
		for tc in aux.Next(sg) do
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_UPDATE_ATTACK)
			e0:SetValue(500)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0)
			local e1=e0:Clone()
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e1)
		end
	end
	if num>1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if num>2 then
		Duel.BreakEffect()
		for ac in aux.Next(sg) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(c33701351.val)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			ac:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			ac:RegisterEffect(e3)
		end
	end
	Duel.ShuffleDeck(tp)
end
function c33701351.val(e,re,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end