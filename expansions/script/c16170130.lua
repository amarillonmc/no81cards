local m=16170130
local cm=_G["c"..m]
cm.name="榻榻米回转"
function cm.initial_effect(c)
	aux.AddCodeList(c,16170120)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thdcon)
	e2:SetTarget(cm.thdtg)
	e2:SetOperation(cm.thdop)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local b1=Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.drtgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and (Duel.GetFlagEffect(tp,m)==0 or not e:IsCostChecked())
	local b2=g:GetClassCount(Card.GetCode)>=2 and (Duel.GetFlagEffect(tp,m+1)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,0)},
		{b2,aux.Stringid(m,1)})
	if op==1 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e:SetOperation(cm.drop)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
		e:SetOperation(cm.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.drtgfilter(c)
	return c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.drtgfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		if Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0 then
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
		if tc:IsLocation(LOCATION_DECK) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,16170120) and c:IsAbleToHand()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
function cm.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE)
		and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function cm.thdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.conffilter(c)
	return not c:IsPublic()
end
function cm.thdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,cm.conffilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,g)
			if not g:GetFirst():IsCode(16170120) then
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		end
	end
end