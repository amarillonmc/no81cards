--摧毁神像
local m=7429902
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
function cm.filtert(c)
	return c:IsPosition(POS_FACEUP) and not c:IsDefenseAbove(1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsPlayerCanDraw(tp,1) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	--local tc=cm.Group_GetLast(g)
	local tc=g:Filter(cm.thfilter,nil):GetFirst()
	Duel.ConfirmCards(0,tc)
	Duel.ConfirmCards(1,tc)
	local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if tc:IsAttribute(ATTRIBUTE_WATER) and tc:IsLevelAbove(6) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(tp)
			if tg:GetCount()>=tc:GetLevel() and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local stg=tg:Select(tp,tc:GetLevel(),tc:GetLevel(),nil)
				Duel.HintSelection(stg)
				if Duel.SendtoDeck(stg,nil,0,REASON_EFFECT)~=0 then
					Duel.BreakEffect()
					Duel.ShuffleDeck(tp)
					local def=tc:GetLevel()*500
					local tc=dg:GetFirst()
					while tc do
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UPDATE_DEFENSE)
						e1:SetValue(-def)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
						tc=dg:GetNext()
					end
					local sg=Duel.GetMatchingGroup(cm.filtert,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
					if sg:GetCount()>0 then
						Duel.BreakEffect()
						Duel.Destroy(sg,REASON_EFFECT)
					end
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
