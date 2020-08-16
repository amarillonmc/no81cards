local m=31480007
local cm=_G["c"..m]
cm.name="神欲大龙卷"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.costfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x1313)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_GRAVE) and not c:IsLocation(LOCATION_HAND) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		local lp=Duel.GetLP(c:GetControler())
		Duel.SetLP(c:GetControler(),lp-500)
	end
end