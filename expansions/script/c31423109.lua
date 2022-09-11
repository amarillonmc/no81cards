local m=31423109
local cm=_G["c"..m]
cm.name="星鱼狂潮『暗星潮』"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.spell_ini(c,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Seine_space_ghoti.sfcode-1,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsCode(Seine_space_ghoti.sfcode) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.filter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)>0 then
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct>0 then
			Duel.ShuffleDeck(1-tp)
			Duel.BreakEffect()
			Duel.Draw(1-tp,ct,REASON_EFFECT)
		end
	end
end