--三和弦歌手 凛
c9910053.named_with_Traid=1
function c9910053.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910053)
	e2:SetCondition(c9910053.thcon)
	e2:SetTarget(c9910053.thtg)
	e2:SetOperation(c9910053.thop)
	c:RegisterEffect(e2)
	c9910053.onfield_effect=e2
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,9910093)
	e3:SetCondition(c9910053.drcon)
	e3:SetCost(c9910053.drcost)
	e3:SetTarget(c9910053.drtg)
	e3:SetOperation(c9910053.drop)
	c:RegisterEffect(e3)
end
function c9910053.thcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
end
function c9910053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,9,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c9910053.thfilter(c)
	return not c:IsCode(9910051) and c:IsAbleToHand()
end
function c9910053.thfilter2(c)
	return c:IsCode(9910051) and c:IsAbleToHand()
end
function c9910053.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<9
		or not Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(9910053,0))
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,0,LOCATION_DECK,9,9,nil)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(1-tp,g)
	local ct=g:FilterCount(Card.IsCode,nil,9910051)
	local thct=0
	if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(9910053,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c9910053.thfilter,1,ct,nil)
		thct=Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
	if thct==0 and Duel.IsExistingMatchingCard(c9910053.thfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910053,2)) then
		Duel.BreakEffect()
		local sg2=Duel.GetFirstMatchingCard(c9910053.thfilter2,tp,LOCATION_DECK,0,nil)
		if sg2 then
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		end
	end
	if thct==3 and Duel.SelectYesNo(tp,aux.Stringid(9910053,3)) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c9910053.negcon)
		e1:SetOperation(c9910053.negop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.ShuffleDeck(tp)
end
function c9910053.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,9910053)<2
end
function c9910053.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910053)
	Duel.RegisterFlagEffect(tp,9910053,RESET_PHASE+PHASE_END,0,1)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c9910053.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910053.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c9910053.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c9910053.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
