--三和弦歌手 加莲
c9910054.named_with_Traid=1
function c9910054.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910054)
	e2:SetCondition(c9910054.thcon)
	e2:SetTarget(c9910054.thtg)
	e2:SetOperation(c9910054.thop)
	c:RegisterEffect(e2)
	c9910054.onfield_effect=e2
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,9910094)
	e3:SetCondition(c9910054.drcon)
	e3:SetCost(c9910054.drcost)
	e3:SetTarget(c9910054.drtg)
	e3:SetOperation(c9910054.drop)
	c:RegisterEffect(e3)
end
function c9910054.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9910054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,9,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c9910054.thfilter(c)
	return not c:IsCode(9910051) and c:IsAbleToHand()
end
function c9910054.thfilter2(c)
	return c:IsCode(9910051) and c:IsAbleToHand()
end
function c9910054.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c9910054.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<9
		or not Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(9910054,0))
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,0,LOCATION_DECK,9,9,nil)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(1-tp,g)
	local ct=g:FilterCount(Card.IsCode,nil,9910051)
	local thct=0
	if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(9910054,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c9910054.thfilter,1,ct,nil)
		thct=Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
	local res=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
		or Duel.IsExistingMatchingCard(c9910054.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	if thct==0 and Duel.IsExistingMatchingCard(c9910054.thfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910054,2)) then
		Duel.BreakEffect()
		local sg2=Duel.SelectMatchingCard(tp,c9910054.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg2 then
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		end
	end
	if thct==3 and res and Duel.SelectYesNo(tp,aux.Stringid(9910054,3)) then
		Duel.BreakEffect()
		local sg3=Duel.GetMatchingGroup(c9910054.rmfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		if sg3:GetCount()>0 then
			Duel.Remove(sg3,POS_FACEUP,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
end
function c9910054.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910054.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c9910054.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c9910054.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
