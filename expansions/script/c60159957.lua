--出千
function c60159957.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60159957,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60159957.e1tg)
	e1:SetOperation(c60159957.e1op)
	c:RegisterEffect(e1)
	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159957,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,60159957)
	e2:SetTarget(c60159957.e2tg)
	e2:SetOperation(c60159957.e2op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

function c60159957.e1tgf(c)
	return c:IsCode(60159957) and c:IsAbleToHand()
end
function c60159957.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60159957.e1tgf,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60159957.e1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60159957.e1tgf,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c60159957.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(60159957)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	c:RegisterFlagEffect(60159957,RESET_PHASE+RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60159957.e2opf(c)
	return c:IsCode(60159957) and c:IsAbleToDeck() and c:IsFaceup()
end
function c60159957.e2op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c60159957.e2opf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #tg>0 then
		Duel.ConfirmCards(1-tp,tg)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #sg==0 then return end
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60159957,2))
			local sg2=sg:RandomSelect(tp,1)
			Duel.SendtoGrave(sg2,REASON_DISCARD+REASON_EFFECT)
		end
		if ct==3 then
			Duel.BreakEffect()
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60159957,3))
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end