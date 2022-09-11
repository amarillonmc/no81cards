local m=31423100
local cm=_G["c"..m]
cm.name="星鱼诞生"
if not pcall(function() require("expansions/script/c31423000") end) then require("expansions/script/c31423000") end
function cm.initial_effect(c)
	Seine_space_ghoti.spell_ini(c,5)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(Seine_space_ghoti.sfcode-1,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
function cm.confilter(c)
	return c:IsCode(Seine_space_ghoti.sfcode) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,0,LOCATION_DECK,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local h1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if c:IsLocation(LOCATION_HAND) then h1:RemoveCard(c) end
		local con1=(Duel.IsPlayerCanDraw(tp,#h1) and h1:FilterCount(Card.IsAbleToDeck,nil)==#h1)
		local h2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local con2=(Duel.IsPlayerCanDraw(1-tp) and h2:FilterCount(Card.IsAbleToDeck,nil)==#h2)
		return (#h1+#h2>0) and (con1 or #h1==0) and (con2 or #h2==0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local num1=Duel.SendtoDeck(h1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local num2=Duel.SendtoDeck(h2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.Draw(tp,num1,REASON_EFFECT)
	Duel.Draw(1-tp,num2,REASON_EFFECT)
end