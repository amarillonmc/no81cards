--逐彩的永夏 七海
require("expansions/script/c9910950")
function c9910966.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910966)
	e1:SetCondition(c9910966.discon)
	e1:SetCost(c9910966.discost)
	e1:SetTarget(c9910966.distg)
	e1:SetOperation(c9910966.disop)
	c:RegisterEffect(e1)
	--Going to grave returns banished to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910978)
	e2:SetCondition(c9910966.tdcon)
	e2:SetTarget(c9910966.tdtg)
	e2:SetOperation(c9910966.tdop)
	c:RegisterEffect(e2)
end
function c9910966.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c9910966.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9910966.rmfilter(c,tp)
	return c:IsSetCard(0x5954) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910966.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove(tp,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c9910966.rmfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910966.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910966.rmfilter,tp,LOCATION_HAND,0,1,1,c)
	if #g>0 and c:IsRelateToEffect(e) and c:IsAbleToRemove(tp,POS_FACEDOWN) then
		g:AddCard(c)
		Duel.ConfirmCards(1-tp,g)
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==2 then
			res=Duel.NegateEffect(ev)
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
function c9910966.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c9910966.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rg=Duel.GetDecktopGroup(tp,3)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,nil)
		and rg:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,0,0)
end
function c9910966.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local res=false
	if #tg>0 then
		res=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		if res then
			Duel.BreakEffect()
			local rg=Duel.GetDecktopGroup(tp,3)
			Duel.ConfirmCards(tp,rg)
			Duel.DisableShuffleCheck()
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			Duel.DisableShuffleCheck(false)
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
