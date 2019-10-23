--战车道的准备
function c9910136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910136+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910136.target)
	e1:SetOperation(c9910136.activate)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910136)
	e2:SetCost(c9910136.retcost)
	e2:SetTarget(c9910136.rettg)
	e2:SetOperation(c9910136.retop)
	c:RegisterEffect(e2)
end
function c9910136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
end
function c9910136.activate(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.Draw(tp,2,REASON_EFFECT)
	local h2=Duel.Draw(1-tp,2,REASON_EFFECT)
	if h1>0 or h2>0 then Duel.BreakEffect() end
	if h1>0 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if g1:GetCount()==0 then return end
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)
	end
	if h2>0 then 
		local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,nil)
		if g2:GetCount()==0 then return end
		Duel.ShuffleHand(1-tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local sg2=g2:Select(1-tp,1,1,nil)
		Duel.SendtoDeck(sg2,nil,0,REASON_EFFECT)
	end
end
function c9910136.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910136.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9910136.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end
