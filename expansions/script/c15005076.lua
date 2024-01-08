local m=15005076
local cm=_G["c"..m]
cm.name="三终渊的废星壳"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
	--ReplaceDraw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,6)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==6 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return Duel.GetMatchingGroupCount(cm.thfilter,p,LOCATION_REMOVED,0,nil)>0 and Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(p)>0
end
function cm.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand() and bit.band(c:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,p,LOCATION_REMOVED,0,1,nil) end
	local dt=Duel.GetDrawCount(p)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,p)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,p,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		local tc=g:RandomSelect(p,1):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,tc)
		end
	end
end