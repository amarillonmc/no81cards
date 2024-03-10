--魔力之源
local m=16670005
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableCounterPermit(0x1)
    c:SetUniqueOnField(1,0,m)
    --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.damp)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
--  local e6=Effect.CreateEffect(c)
--	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--	e6:SetRange(LOCATION_SZONE)
--	e6:SetCode(EVENT_REMOVE_COUNTER+0x1)
--	e6:SetOperation(cm.ctop1)
--	c:RegisterEffect(e6)
    --
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66104644,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_CANNOT_INACTIVATE)
	e4:SetCost(cm.spcost)
    e4:SetCondition(cm.spcon2)
    e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(cm.desreptg)
	e5:SetOperation(cm.desrepop)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_RCOUNTER_REPLACE+0x1)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(cm.rcon)
	e6:SetOperation(cm.rop)
	c:RegisterEffect(e6)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,180,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,180,REASON_COST)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,ev)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.chkfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,1,nil)
end
function cm.filter(c)
	return c:IsAbleToRemove()
end
function cm.chkfilter(c)
	return not c:IsAbleToRemove()
end
function cm.damp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local num=0
    for tc in aux.Next(eg) do
			num=num+tc:GetCounter(0x1)
	end
	e:SetLabel(num)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then
		Duel.BreakEffect()
		e:GetHandler():AddCounter(0x1,ct)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,1,nil)
	end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300+18000)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local num=18000
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,nil)
    local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		num=num+ct*300
	end
    Duel.Damage(1-tp,num,REASON_EFFECT)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler():GetCounter(0x1)
    local n=math.ceil(c/2)
	if chk==0 then return c>0 and not e:GetHandler():IsReason(REASON_RULE+REASON_REPLACE)
		and e:GetHandler():IsCanRemoveCounter(tp,0x1,n,REASON_EFFECT) end
	return true
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetCounter(0x1)
    local n=math.ceil(c/2)
	e:GetHandler():RemoveCounter(tp,0x1,n,REASON_EFFECT)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated() and bit.band(r,REASON_COST)~=0 and e:GetHandler():GetCounter(0x1)>=ev
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1,ev,REASON_EFFECT)
end
