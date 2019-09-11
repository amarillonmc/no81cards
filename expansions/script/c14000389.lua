--对荒碑的探寻
local m=14000389
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Gravalond or c:IsCode(14000380))
end
function cm.filter(c)
	return cm.Grava(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if sg1:GetCount()>0 then
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end