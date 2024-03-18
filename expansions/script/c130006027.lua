--囚徒与恶眼
local cm,m=GetID()
function cm.initial_effect(c)
	--search limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop2)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,0)
		local e3=e1:Clone()
		e3:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(e3,0)
	end
end
function cm.filter(c,e)
	return c:GetPreviousLocation()==LOCATION_DECK and c:IsOnField() and (c:IsStatus(STATUS_EFFECT_ENABLED) or not c:IsLocation(LOCATION_MZONE) or c:IsStatus(STATUS_CHAINING) or c:IsFacedown()) and not ((Duel.CheckEvent(EVENT_SUMMON_SUCCESS) or Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS)) and e:GetCode()==EVENT_MOVE and c:IsLocation(LOCATION_MZONE))
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,e)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) local g=eg:Filter(cm.filter,nil,e) e:GetLabelObject():GetLabelObject():Merge(g) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	--e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(g)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) local g=e:GetLabelObject() Duel.SendtoDeck(g,nil,0,REASON_RULE) g:Clear() end)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,0)
	e1:SetLabelObject(e2)
end