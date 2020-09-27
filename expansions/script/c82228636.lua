local m=82228636
local cm=_G["c"..m]
cm.name="猎兽龙"
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e1:SetCountLimit(1,m)  
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end 
	Duel.SetChainLimit(cm.chainlimit)  
end  
function cm.chainlimit(e,rp,tp)  
	return not (e:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsRace(RACE_BEAST))
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()   
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)  
	e1:SetTarget(cm.sumlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END,2)  
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(e:GetHandler())  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_CHAIN_SOLVING)  
	e2:SetCondition(cm.discon)  
	e2:SetOperation(cm.disop)  
	e2:SetReset(RESET_PHASE+PHASE_END,2)  
	Duel.RegisterEffect(e2,tp)  
end  
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)  
	return c:IsRace(RACE_BEAST) 
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_BEAST)
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)  
end  