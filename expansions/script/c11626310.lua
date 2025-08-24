--分裂的隐匿虫
function c11626310.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11626310,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11626310+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c11626310.target)
	e1:SetOperation(c11626310.activate)
	c:RegisterEffect(e1) 
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11626310,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,11626310+EFFECT_COUNT_CODE_OATH)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c11626310.target2)
	e2:SetOperation(c11626310.activate2)
	c:RegisterEffect(e2)	 
end
function c11626310.filter(c)
	return c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c11626310.filter2(c)
	return c:IsSetCard(0x3220) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c11626310.posfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck() and not c:IsSetCard(0x3220) 
end
function c11626310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11626310.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11626310.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(tp,c11626310.filter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	local dc=dg:GetFirst()
	while dc do
		Duel.SendtoDeck(dc,1-tp,2,REASON_EFFECT)
		if not dc:IsLocation(LOCATION_DECK) then return end
		Duel.ShuffleDeck(1-tp) 
		dc:ReverseInDeck()
		dc=dg:GetNext()
	end
end
---
function c11626310.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11626310.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c11626310.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c11626310.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)~=0 then
		Duel.Draw(p,d,REASON_EFFECT) 
	end
end
