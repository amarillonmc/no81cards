--无限可能性
local m=33703013
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,ec)
	if chk==0 then return #hg>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,hg,#hg,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,ec)
	local dg=hg:Filter(Card.IsDiscardable,nil,REASON_EFFECT)
	if #hg==0 or Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)==0 then return end
	local ct=Duel.GetOperatedGroup():GetCount()
	Duel.Recover(tp,ct*ct*100,REASON_EFFECT)
end