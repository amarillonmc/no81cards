local m=53799141
local cm=_G["c"..m]
cm.name="惨败"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return not (re:IsActiveType(TYPE_CONTINUOUS) and (ph==PHASE_DRAW or ph==PHASE_STANDBY))
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	if Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)>0 then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e:SetProperty(0)
	end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
end
