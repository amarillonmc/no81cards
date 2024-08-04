--三和弦歌手 奈绪
c9910055.named_with_Traid=1
function c9910055.initial_effect(c)
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
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910055)
	e2:SetCondition(c9910055.thcon)
	e2:SetTarget(c9910055.thtg)
	e2:SetOperation(c9910055.thop)
	c:RegisterEffect(e2)
	c9910055.onfield_effect=e2
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9910095)
	e3:SetCost(c9910055.drcost)
	e3:SetTarget(c9910055.drtg)
	e3:SetOperation(c9910055.drop)
	c:RegisterEffect(e3)
end
function c9910055.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
		and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousLocation(LOCATION_EXTRA))
end
function c9910055.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910055.cfilter,1,nil,1-tp)
end
function c9910055.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=9 end
end
function c9910055.thfilter(c)
	return c:IsCode(9910051) and c:IsAbleToHand()
end
function c9910055.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return false end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.ConfirmDecktop(tp,9)
	local g=Duel.GetDecktopGroup(tp,9)
	if #g~=9 then return end
	local ct=g:FilterCount(Card.IsCode,nil,9910051)
	if ct>0 and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910055,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:FilterSelect(tp,Card.IsAbleToHand,1,ct,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleHand(tp)
	end
	if ct==0 and Duel.IsExistingMatchingCard(c9910055.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910055,1)) then
		Duel.BreakEffect()
		local sg2=Duel.SelectMatchingCard(tp,c9910055.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
	Duel.ShuffleDeck(tp)
end
function c9910055.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c9910055.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,2)
end
function c9910055.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()<2 then return end
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,2,2,nil)
		aux.PlaceCardsOnDeckBottom(p,sg)
	end
end
