-- 混沌军势
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
end
function s.get_count(tp)
	local base=Duel.GetFlagEffect(tp,60002148)
	local neg=Duel.GetFlagEffect(tp,60012250)
	return base-neg
end
function s.tdfilter(c,tp)
	return c:IsLevelBelow(3) and c:IsAbleToDeck()
end
function s.tdfilter2(c,tp)
	return c:IsLevelBelow(6) and c:IsAbleToDeck()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local filter=s.tdfilter
	if s.get_count(tp)>=15 then
		filter=s.tdfilter2
	end
	if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.GetMatchingGroup(filter,tp,0,LOCATION_MZONE,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,#g,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local filter=s.tdfilter
	if s.get_count(tp)>=15 then
		filter=s.tdfilter2
	end
	local g=Duel.GetMatchingGroup(filter,tp,0,LOCATION_MZONE,nil,tp)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end