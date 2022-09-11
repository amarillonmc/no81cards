local m=31423108
local cm=_G["c"..m]
cm.name="星鱼狂潮『微星潮』"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.spell_ini(c,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Seine_space_ghoti.sfcode-1,1))
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
function cm.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end