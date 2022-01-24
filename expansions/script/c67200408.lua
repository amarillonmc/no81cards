--术结天缘 残光相依
function c67200408.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,67200408+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67200408.target)
	e1:SetOperation(c67200408.activate)
	c:RegisterEffect(e1)  
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200408,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67200409)
	e2:SetTarget(c67200408.thtg)
	e2:SetOperation(c67200408.thop)
	c:RegisterEffect(e2)  
end
function c67200408.filter(c)
	return c:IsCode(67200400) and not c:IsForbidden() and c:IsAbleToHand()
end
function c67200408.filter2(c)
	return c:IsCode(67200401) and not c:IsForbidden() and c:IsAbleToHand()
end
function c67200408.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200408.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c67200408.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200408.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c67200408.filter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c67200408.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleDeck(tp)
	local cg=sg1:Select(1-tp,1,1,nil)
	local tc=cg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	if tc then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
end
--
function c67200408.thfilter1(c)
	return c:IsSetCard(0x5671) and c:IsAbleToDeck()
end
function c67200408.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200408.thfilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	--
	local g=Duel.GetMatchingGroup(c67200408.thfilter1,tp,LOCATION_GRAVE,0,nil)
	local count=g:GetCount()
	local lvt={}
	while count>0 do
		local tlv=count
		lvt[tlv]=tlv
		count=count-1
	end
	local pc=1
	for i=1,g:GetCount() do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	--
	local dgc=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1)
	local lvt2={} 
	while dgc>0 do
		local tlv2=dgc
		lvt2[tlv2]=tlv2
		dgc=dgc-1
	end
	local pc2=1
	for i2=1,Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1) do
		if lvt2[i2] then lvt2[i2]=nil lvt2[pc2]=i2 pc2=pc2+1 end
	end
	lvt2[pc2]=nil
	--
	if g:GetCount()>16 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200408,2))
		local lv0=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		Duel.RemoveCounter(tp,1,0,0x1,lv0,REASON_COST)
		e:SetLabel(lv0)	 
	else
		if g:GetCount()>dgc then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200408,2))
			local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
			Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_COST)
			e:SetLabel(lv)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200408,2))
			local lv2=Duel.AnnounceNumber(tp,table.unpack(lvt2))
			Duel.RemoveCounter(tp,1,0,0x1,lv2,REASON_COST)
			e:SetLabel(lv2)
		end
	end
end
function c67200408.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv3=e:GetLabel()
	--if not Duel.IsCanRemoveCounter(tp,1,0,0x1,lv3,REASON_COST) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67200408.thfilter1,tp,LOCATION_GRAVE,0,lv3,lv3,nil)
	if g:GetCount()>0 then
		--Duel.ConfirmCards(1-tp,g)
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct==0 then return end
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end

