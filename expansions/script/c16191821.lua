--幻想大剑-阳炎一闪
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16170120)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16170130)
	e2:SetCondition(s.thdcon)
	e2:SetTarget(s.thdtg)
	e2:SetOperation(s.thdop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local b1=Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.drtgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and (Duel.GetFlagEffect(tp,16170130)==0 or not e:IsCostChecked())
	local b2=g:GetClassCount(Card.GetCode)>=2 and (Duel.GetFlagEffect(tp,16170131)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e:SetOperation(s.drop)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.RegisterFlagEffect(tp,16170130,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
		e:SetOperation(s.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,16170131,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.drtgfilter(c)
	return c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.drtgfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		if Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0 then
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
		if tc:IsLocation(LOCATION_DECK) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.thfilter(c)
	return aux.IsCodeListed(c,16170120) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
function s.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE)
		and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function s.thdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.conffilter(c)
	return not c:IsPublic()
end
function s.thdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.conffilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,g)
			if not g:GetFirst():IsCode(16170120) then
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		end
	end
end