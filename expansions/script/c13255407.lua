--增殖的A
local m=13255407
local cm=_G["c"..m]
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	
end
function cm.chainfilter(re,tp,cid)
	return re:GetActivateLocation()==LOCATION_HAND
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetLabel(0)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.drcon)
	e0:SetOperation(cm.drop)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabelObject(e0)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.filter(c,sp)
	return c:IsSummonPlayer(sp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.filter,nil,1-tp)
	local de=e:GetLabelObject()
	if de then
		de:SetLabel(de:GetLabel()+ct)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>1
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local ct=math.floor(e:GetLabel()/2)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
