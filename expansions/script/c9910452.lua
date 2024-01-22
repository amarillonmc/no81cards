--永恒辉映的韶光
function c9910452.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetTarget(c9910452.target)
	e1:SetOperation(c9910452.activate)
	e1:SetValue(c9910452.zones)
	c:RegisterEffect(e1)
end
function c9910452.filter(c,b,e,tp)
	local b1=b and not c:IsForbidden()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	return c:IsCode(9910451) and (b1 or b2)
end
function c9910452.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local sp=Duel.IsExistingMatchingCard(c9910452.filter,tp,LOCATION_DECK,0,1,nil,false,e,tp)
	if p0==p1 or sp then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c9910452.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910452.filter,tp,LOCATION_DECK,0,1,nil,b,e,tp) end
end
function c9910452.activate(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910452,1))
	local sg=Duel.SelectMatchingCard(tp,c9910452.filter,tp,LOCATION_DECK,0,1,1,nil,b,e,tp)
	local sc=sg:GetFirst()
	local res=false
	local b1=b and not sc:IsForbidden()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=0
	if b1 and not b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910452,2))
	end
	if not b1 and b2 then
		op=Duel.SelectOption(tp,1152)+1
	end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910452,2),1152)
	end
	if op==0 then
		if Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),0x1950,1)
			local tc=g:GetFirst()
			while tc do
				tc:AddCounter(0x1950,1)
				tc=g:GetNext()
			end
			res=true
		end
	end
	if op==1 then
		res=Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0
	end
	if not res or Duel.GetCounter(tp,1,1,0x1950)<5 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910452,0))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
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
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c9910452.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9910452.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c9910452.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then
		local tg=g:Filter(Card.IsAbleToHand,nil)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		Duel.ShuffleDeck(tp)
	end
end
