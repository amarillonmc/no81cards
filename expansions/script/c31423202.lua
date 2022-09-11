local m=31423202
local cm=_G["c"..m]
cm.name="星鱼溯洄"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.spell_ini(c,3)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return Seine_space_ghoti.climax_filter(c) and c:IsAbleToDeck()
end
function cm.td_filter(c)
	return c:IsCode(Seine_space_ghoti.sfcode) and c:IsLocation(LOCATION_DECK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE+LOCATION_REMOVED,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local grg=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED,0)
	if #grg==0 then return end
	Duel.ConfirmCards(1-tp,grg)
	g=grg:Filter(cm.filter,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.BreakEffect()
	local num=g:FilterCount(cm.td_filter,nil)
	--local num=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	for i=1,num do
		local tk=Duel.CreateToken(1-tp,Seine_space_ghoti.sfcode)
		Duel.SendtoDeck(tk,1-tp,SEQ_DECKBOTTOM,REASON_EFFECT)
		tk:ReverseInDeck()
	end
end