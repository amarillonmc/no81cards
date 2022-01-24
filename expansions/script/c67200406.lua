--术结天缘 水泡冲击
function c67200406.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200406+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67200406.target)
	e1:SetOperation(c67200406.activate)
	c:RegisterEffect(e1) 
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200406,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,67200407)
	e2:SetTarget(c67200406.thtg)
	e2:SetOperation(c67200406.thop)
	c:RegisterEffect(e2)   
end
--
function c67200406.cfilter(c)
	return c:IsSetCard(0x5671) and c:IsFaceup()
end
function c67200406.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c67200406.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(nil,r,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
	local rec=ct*500
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c67200406.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c67200406.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,c)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
	--
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
end
--
function c67200406.thfilter1(c)
	return c:IsSetCard(0x5671) and c:IsAbleToDeck()
end
function c67200406.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200406.thfilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	--
	local g=Duel.GetMatchingGroup(c67200406.thfilter1,tp,LOCATION_GRAVE,0,nil)
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
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200406,2))
		local lv0=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
		Duel.RemoveCounter(tp,1,0,0x1,lv0,REASON_COST)
		e:SetLabel(lv0)	 
	else
		if g:GetCount()>dgc then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200406,2))
			local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
			Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_COST)
			e:SetLabel(lv)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200406,2))
			local lv2=Duel.AnnounceNumber(tp,table.unpack(lvt2))
			Duel.RemoveCounter(tp,1,0,0x1,lv2,REASON_COST)
			e:SetLabel(lv2)
		end
	end
end
function c67200406.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv3=e:GetLabel()
	--if not Duel.IsCanRemoveCounter(tp,1,0,0x1,lv3,REASON_COST) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67200406.thfilter1,tp,LOCATION_GRAVE,0,lv3,lv3,nil)
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

