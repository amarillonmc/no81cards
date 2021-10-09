--春之樱·冲田总司
function c9950323.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),2,2)
	 --mill
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c9950323.sumsuc)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950323,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,9950323)
	e2:SetCondition(c9950323.condition)
	e2:SetTarget(c9950323.target)
	e2:SetOperation(c9950323.operation)
	c:RegisterEffect(e2)
	--deck search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950323,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99503230)
	e1:SetTarget(c9950323.target2)
	e1:SetOperation(c9950323.operation2)
	c:RegisterEffect(e1)
end
function c9950323.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(9950323,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950323,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950323,1))
end
function c9950323.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950323.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c9950323.ctfilter,tp,LOCATION_MZONE,0,e:GetHandler())
		if ct==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9950323.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xba5)
end
function c9950323.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c9950323.ctfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if ct==0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmDecktop(tp,ct)
	tg=g:Filter(c9950323.thfilter,nil)
	if tg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(tc,REASON_RULE)
		end
		g:RemoveCard(tc)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	else
		Duel.ShuffleDeck(tp)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950323,0))
  Duel.Hint(HINT_SOUND,0,aux.Stringid(9950323,1))
end
function c9950323.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9950323)~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9950323.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function c9950323.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xba5)
end
function c9950323.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c9950323.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9950323,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c9950323.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end