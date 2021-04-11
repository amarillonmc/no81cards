--永恒辉映的韶光
function c9910452.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910452+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910452.target)
	e1:SetOperation(c9910452.activate)
	c:RegisterEffect(e1)
end
function c9910452.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),0x1950,1) end
end
function c9910452.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),0x1950,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1950,1)
		tc=g:GetNext()
	end
	if Duel.GetCounter(tp,1,1,0x1950)<5 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910452,0))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_SZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCountLimit(1)
		e1:SetCost(c9910452.thcost)
		e1:SetTarget(c9910452.thtg)
		e1:SetOperation(c9910452.thop)
		c:RegisterEffect(e1)
	end
end
function c9910452.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9910452.cfilter(c)
	return c:GetCounter(0x1950)>0
end
function c9910452.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c9910452.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
end
function c9910452.filter(c,e,tp,ft)
	return c:IsSetCard(0x9950) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c9910452.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c9910452.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct<=0 or not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if g:IsExists(c9910452.filter,1,nil,e,tp,ft) and Duel.SelectYesNo(tp,aux.Stringid(9910452,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=g:FilterSelect(tp,c9910452.filter,1,1,nil,e,tp,ft):GetFirst()
			if tc then
				if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
