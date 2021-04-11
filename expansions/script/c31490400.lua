local m=31490400
local cm=_G["c"..m]
cm.name="圣燧烽圣域 阳炎圣堂"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.handop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_HAND,0)
	e3:SetCondition(cm.immcon)
	e3:SetTarget(cm.etarget)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
end
function cm.handop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local unlimit_g=g:Filter(Card.IsPublic,nil):Filter(Card.IsSetCard,nil,0x310)
	g:Sub(unlimit_g)
	local num=g:GetCount()
	local hand_max=6
	local hand_e=Duel.IsPlayerAffectedByEffect(tp,EFFECT_HAND_LIMIT)
	if hand_e then 
		hand_max=hand_e:GetValue()
	end
	if num>hand_max then
		Duel.DiscardHand(tp,aux.TRUE,num-hand_max,num-hand_max,REASON_RULE,unlimit_g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(unlimit_g:GetCount()+hand_max)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.handlimvalue(e)
	return Duel.GetMatchingGroup(Card.IsPublic,e:GetHandlerPlayer(),LOCATION_HAND,0,nil):FilterCount(Card.IsSetCard,0x310)+6
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	local numhand=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil):FilterCount(Card.IsSetCard,nil,0x9310)
	local numfield=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP):FilterCount(Card.IsSetCard,nil,0x9310)
	return numhand>numfield
end
function cm.etarget(e,c)
	if not c:IsSetCard(0x9310) then return false end
	if c:IsLocation(LOCATION_HAND) then return c:IsPublic() end
	if c:IsLocation(LOCATION_MZONE) then return c:IsPosition(POS_FACEUP) end
end
function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.drawfilter(c)
	return c:IsPublic() and c:IsAbleToDeck() and c:IsSetCard(0x9310)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.drawfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,cm.drawfilter,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount()+1,REASON_EFFECT)
end