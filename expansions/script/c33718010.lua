--水物语-黄粱
function c33718010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c33718010.target)
	e1:SetOperation(c33718010.activate)
	c:RegisterEffect(e1)
end
function c33718010.filter(c)
	return c:IsSetCard(0xce) or c:IsSetCard(0xcd) and c:IsAbleToDeck() and not c:IsPublic()
end
function c33718010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(c33718010.filter,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end 
function c33718010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.IsExistingMatchingCard(tp,c33718010.filter,tp,LOCATION_HAND,0,1,99,nil)
	if g:GetCount()>0 then 
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
			ct=ct+2
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetOperation(c33718010.endactivate)
			Duel.RegisterEffect(e2,tp)
		end
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function c33718010.endactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(e:GetOwnerPlayer(),LOCATION_HAND,0)
	Duel.SendtoDeck(g,REASON_EFFECT)
end