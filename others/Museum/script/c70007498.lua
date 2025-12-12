--多元闪刀术式-爆风偏向
local m=70007498
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
end
	function cm.cfilter(c)
	return c:GetSequence()<5
end
	function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
	function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsPlayerCanDiscardDeck(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,2)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_DECKDES+CATEGORY_TOEXTRA)
	end
end
	function cm.filter(c,tp)
	return c:GetSequence()>=5 and c:IsControler(1-tp) and c:IsAbleToDeck()
end
	function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,2)
	local g2=Duel.GetDecktopGroup(1-tp,2)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0
		and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
		and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil,tp)
		Duel.DisableShuffleCheck(false)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
