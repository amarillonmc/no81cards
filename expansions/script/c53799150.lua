local m=53799150
local cm=_G["c"..m]
cm.name="下一个世界"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:GetFlagEffect(m)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==5 and not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>5 then ct=5 end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	if g:IsExists(aux.NOT(aux.FilterBoolFunction(Card.IsLocation,LOCATION_REMOVED)),1,nil) then return end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(cm.retcon)
	e1:SetOperation(cm.retop)
	e1:SetLabelObject(g)
	Duel.RegisterEffect(e1,tp)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_RULE
end
function cm.retfilter(c)
	return c:GetFlagEffect(m)>0 and c:IsAbleToHand()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.retfilter,nil)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local thg=sg:Select(tp,1,1,nil)
		if Duel.SendtoHand(thg,nil,REASON_EFFECT)~=0 and thg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,thg)
			g:Sub(thg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tdg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil)
			Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
		end
	end
	if #g==0 then e:Reset() end
end
