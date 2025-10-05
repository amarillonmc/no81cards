--芙兰黛莉卡
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337540)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1193)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1190)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
function s.spfilter(c)
	return c:IsFaceup() and c:IsCode(17337480)
end
function s.spfilter2(c)
	return c:IsCode(17337540) and c:IsFaceup()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) or
		Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil))
end
function s.thfilter(c)
	return c:IsSetCard(0x3f50) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local b1=#g>=3 and c:IsLocation(LOCATION_MZONE)
	local b2=g:GetClassCount(Card.GetCode,nil)>=3
	if chk==0 then return (b1 or b2) and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		local b1=#g>=3 and c:IsPreviousLocation(LOCATION_MZONE)
		local b2=g:GetClassCount(Card.GetCode,nil)>=3
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,3,3,nil)
			Duel.ConfirmCards(1-tp,sg)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tg=sg:RandomSelect(1-tp,1)
			Duel.ShuffleDeck(tp)
			tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			sg:DeleteGroup()
		else 
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
			sg:KeepAlive()
			Duel.ConfirmCards(1-tp,sg)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tg=sg:RandomSelect(1-tp,1)
			Duel.ShuffleDeck(tp)
			tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			sg:DeleteGroup()
		end
	end
end
function s.rmfilter(c)
	return c:IsSetCard(0x3f50) and c:IsAbleToHand() and c:IsFaceup()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end