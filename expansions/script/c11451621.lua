--琉霓羽
--21.08.24
local m=11451621
local cm=_G["c"..m]
function cm.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.rmfilter(c)
	if not c:IsAbleToRemove() then return false end
	local dest=c:GetLeaveFieldDest()
	if dest&LOCATION_REMOVED>0 or dest&LOCATION_DECK>0 then return true end
	local eset={c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)}
	for _,te in pairs(eset) do
		if te:GetValue()==LOCATION_REMOVED then return true end
	end
	return false
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
end