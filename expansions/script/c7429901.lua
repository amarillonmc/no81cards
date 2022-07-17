--垂钓时光
local m=7429901
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_END_PHASE,TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.Group_GetLast(g)
	local tc=g:GetFirst()
	while tc do
		local sc=tc
		local tc=g:GetNext()
		if tc then
		else
			return sc
		end
	end
end
function cm.thfilter(c)
	return c:GetSequence()==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsPlayerCanDraw(tp,1) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local tc=g:Filter(cm.thfilter,nil):GetFirst()
	Duel.ConfirmCards(0,tc)
	Duel.ConfirmCards(1,tc)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if tc:IsAttribute(ATTRIBUTE_WATER) and tc:IsLevelAbove(6) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(tp)
			if tg:GetCount()>=tc:GetLevel() and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local stg=tg:Select(tp,tc:GetLevel(),tc:GetLevel(),nil)
				Duel.HintSelection(stg)
				if Duel.SendtoDeck(stg,nil,0,REASON_EFFECT)~=0 then
					Duel.BreakEffect()
					Duel.ShuffleDeck(tp)
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	else
		Duel.ShuffleDeck(tp)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
