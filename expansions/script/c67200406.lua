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
function c67200406.thfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToDeck()
end
function c67200406.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200406.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	local g=Duel.GetMatchingGroup(c67200406.thfilter,tp,LOCATION_GRAVE,0,nil)
	local count=g:GetCount()
	local lvt={}
	local tc=g:GetFirst()
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
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200406,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_COST)
	e:SetLabel(lv)
end
function c67200406.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if not Duel.IsCanRemoveCounter(tp,1,0,0x1,lv,REASON_COST) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c67200406.thfilter,tp,LOCATION_GRAVE,0,lv,lv,nil)
	if g:GetCount()>0 then
		--Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
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


