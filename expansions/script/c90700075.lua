local m=90700075
local cm=_G["c"..m]
cm.name="端世坏=狱炎耶拉界"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(cm.enumop)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	--c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(m)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetTargetRange(1,0)
	--c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	--c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e6:SetCode(EFFECT_SEND_REPLACE)
	e6:SetTarget(cm.reptg)
	e6:SetValue(cm.repval)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_DRAW)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetRange(LOCATION_HAND+LOCATION_DECK)
	e7:SetCost(cm.actcost)
	e7:SetOperation(cm.actop)
	e7:SetCountLimit(1,m+100000000+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e7)
	e1:SetLabelObject(e7)
end
function cm.enumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e:SetCode(m)
	e:SetTargetRange(1,0)
	Duel.RegisterEffect(e,tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0)
	g:ForEach(
		function (tc)
			if not ((tc:IsSetCard(0xbb) and tc:IsType(TYPE_MONSTER)) or tc:IsCode(91588074)) then return end
			local code=tc:GetCode()
			if not tc:IsLocation(LOCATION_EXTRA) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,0))
				e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
				e1:SetType(EFFECT_TYPE_IGNITION)
				e1:SetRange(LOCATION_HAND)
				e1:SetCountLimit(1,m)
				e1:SetCondition(cm.con)
				e1:SetTarget(cm.tgtg)
				e1:SetOperation(cm.tgop)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(m,1))
				e2:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
				e2:SetType(EFFECT_TYPE_QUICK_O)
				e2:SetCode(EVENT_CHAINING)
				e2:SetRange(LOCATION_HAND)
				e2:SetCountLimit(1,m+100000000)
				e2:SetCondition(cm.qtgcon)
				e2:SetTarget(cm.qtgtg)
				e2:SetOperation(cm.qtgop)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetDescription(aux.Stringid(m,2))
				e3:SetCategory(CATEGORY_DECKDES)
				e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
				e3:SetCode(EVENT_TO_GRAVE)
				e3:SetCountLimit(2,m+200000000)
				e3:SetProperty(EFFECT_FLAG_DELAY)
				e3:SetCondition(cm.hdtgcon)
				e3:SetTarget(cm.hdtgtg)
				e3:SetOperation(cm.hdtgop)
				tc:RegisterEffect(e3)
			end
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(m,3))
			e4:SetCategory(CATEGORY_TODECK)
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetRange(LOCATION_GRAVE)
			e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			e4:SetCountLimit(2,m+300000000)
			e4:SetCondition(cm.con)
			e4:SetCost(aux.bfgcost)
			--e4:SetTarget(cm.rmtg)
			--e4:SetOperation(cm.rmop)
			e4:SetTarget(cm.tdtg)
			e4:SetOperation(cm.tdop)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetDescription(aux.Stringid(m,4))
			e5:SetCategory(CATEGORY_DECKDES)
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e5:SetProperty(EFFECT_FLAG_DELAY)
			e5:SetCode(EVENT_SUMMON_SUCCESS)
			e5:SetCountLimit(1,m+400000000)
			e5:SetCondition(cm.con)
			e5:SetTarget(cm.ddtg)
			e5:SetOperation(cm.ddop)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EVENT_SPSUMMON_SUCCESS)
			tc:RegisterEffect(e6)
		end
	)
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	e:SetLabel(0)
	if c:IsLocation(LOCATION_DECK) then e:SetLabel(1) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.RegisterFlagEffect(tp,m+e:GetHandler():GetCode(),RESET_PHASE+PHASE_END,nil,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.IsPlayerCanDiscardDeck(tp,1) then
			Duel.BreakEffect()
			Duel.DiscardDeck(tp,3,REASON_EFFECT)
		end
	end
end
function cm.qtgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and Duel.IsPlayerAffectedByEffect(tp,m) and Duel.GetFlagEffect(tp,m+e:GetHandler():GetCode())==0
end
function cm.qtgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.RegisterFlagEffect(tp,m+e:GetHandler():GetCode(),RESET_PHASE+PHASE_END,nil,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.qtgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)>0 then
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
	end
end
function cm.hdtgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(tp,m) and Duel.GetFlagEffect(tp,m+e:GetHandler():GetCode())==0
end
function cm.hdtgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.RegisterFlagEffect(tp,m+e:GetHandler():GetCode(),RESET_PHASE+PHASE_END,nil,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function cm.hdtgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,5)
	--local g2=Duel.GetDecktopGroup(1-tp,5)
	--g1:Merge(g2)
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g1,REASON_EFFECT)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove()  and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,c) and c:IsAbleToRemove() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:AddCard(e:GetHandler())
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) and Duel.IsPlayerAffectedByEffect(tp,m) and Duel.GetFlagEffect(tp,m+e:GetHandler():GetCode())==0 end
	Duel.RegisterFlagEffect(tp,m+e:GetHandler():GetCode(),RESET_PHASE+PHASE_END,nil,1)
	local ct=5
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,m) and Duel.GetFlagEffect(tp,m+e:GetHandler():GetCode())==0
end
function cm.thfilter(c)
	return (c:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToHand() and ((c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER)))-- or c:IsCode(91588074))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	Duel.RegisterFlagEffect(tp,m+e:GetHandler():GetCode(),RESET_PHASE+PHASE_END,nil,1)
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:GetDestination()==LOCATION_REMOVED and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_COST)~=0 and re and re:GetHandler():IsSetCard(0xbb) and re:GetCode()==EFFECT_SPSUMMON_PROC and eg:IsExists(cm.repfilter,1,nil,tp) end
	local g=eg:Filter(cm.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.shop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.repval(e,c)
	return false
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
end