--点晴之手-Left
local m=14000042
local cm=_G["c"..m]
cm.named_with_another=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.ANOTHER(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_another
end
function cm.filter(c)
	return cm.ANOTHER(c) and c:IsAbleToRemove()
end
function cm.cfilter(c)
	return cm.ANOTHER(c) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,2,nil,LOCATION_REMOVED) then
		Duel.BreakEffect()
		local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_REMOVED,0,nil)
		local ct=g1:GetCount()
		if ct>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-ct*800)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.lpcon)
	e1:SetOperation(cm.lpop)
	Duel.RegisterEffect(e1,tp)
	if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,14000041)==0
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,14000041,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*400,REASON_EFFECT)
	end
end