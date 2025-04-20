--超能力转化
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end

function s.filter01(c)
	return c:IsSetCard(0x603) and c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	if Duel.Draw(p,g:GetCount(),REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(s.filter01,tp,LOCATION_REMOVED,0,nil)>=1 and Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,1,nil)
		if g2:GetCount()==0 then return end
		Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		if Duel.Draw(p,g2:GetCount(),REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(s.filter01,tp,LOCATION_REMOVED,0,nil)>=3 and Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
		
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local g3=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,1,nil)
			if g3:GetCount()==0 then return end
			Duel.SendtoDeck(g3,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.ShuffleDeck(p)
			Duel.Draw(p,g3:GetCount(),REASON_EFFECT)
		end
	end
	
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x603) and re:GetHandler():IsType(TYPE_MONSTER) and bit.band(r,REASON_EFFECT)>0
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,6))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e2,tp)
end
function s.filter22(c)
	return c:IsSetCard(0x603) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter22),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local result = Duel.SelectYesNo(tp,aux.Stringid(id,5))
	if not result then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter22),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end