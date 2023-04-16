local m=53727011
local cm=_G["c"..m]
cm.name="多维度之桥"
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SSET)
end
function cm.dfilter(c)
	return aux.IsCodeListed(c,53727003) and c:IsFacedown() and c:IsAbleToDeck()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(function(c)return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)end,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	local ct=Duel.GetMatchingGroupCount(function(c)return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)end,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,ct,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetCount())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,#g,0,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tdg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct=e:GetLabel()+1
	if dcount==0 then return end
	if g:GetCount()<ct then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local og=g:Clone()
	for tc in aux.Next(g) do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			if #og>ct then og:RemoveCard(tc) else break end
		end
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	local thg=og:Filter(Card.IsAbleToHand,nil)
	if #thg>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
		Duel.ShuffleHand(tp)
	end
	Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and aux.exccon(e)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable(true) end
	Duel.SetTargetCard(eg:Filter(cm.cfilter,nil,tp))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg:Filter(cm.cfilter,nil,tp),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local rg=g:Clone()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if #rg>1 then rg=g:Select(tp,1,1,nil) end
	Duel.HintSelection(rg)
	if Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)~=0 and rg:GetFirst():IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
	end
end
