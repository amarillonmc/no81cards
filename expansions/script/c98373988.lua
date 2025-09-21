--幻在之世
function c98373988.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98373988+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c98373988.activate)
	c:RegisterEffect(e1)
	--Send to Deck & Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98373988,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,98373988+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c98373988.drtg)
	e2:SetOperation(c98373988.drop)
	c:RegisterEffect(e2)
end
function c98373988.setfilter(c)
	return c:IsCode(98373992) and c:IsSSetable()
end
function c98373988.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98373988.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98373988,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
	end
end
function c98373988.tdfilter(c)
	return c:IsAbleToDeck() and not c:IsPublic()
end
function c98373988.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98373988.tdfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and g:IsExists(Card.IsSetCard,1,nil,0xaf0) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c98373988.gcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0xaf0)
end
function c98373988.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c98373988.tdfilter,p,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(p,c98373988.gcheck,false,1,#g)
	if tg:GetCount()>0 then
		Duel.ConfirmCards(1-p,tg)
		local ct=Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		if ct==0 then return end
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
