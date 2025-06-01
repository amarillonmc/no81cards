--真典 星之记忆
local s,id=GetID()
function s.immune(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.filter(c)
    return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,nil)<=0 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.efilter(e,re,ec)
	local rc=re:GetHandler()
	if re==e then return false end
	if rc==ec then return false end
	return re:GetOwnerPlayer()==ec:GetControler()
end
function s.cntac(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(aux.IsDualState)
    e1:SetCost(s.tfcost)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
end
function s.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.sfilter(c)
	return c:IsSetCard(0x5ca0) and c:IsAbleToHand()
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActivated() then
		Debug.Message(ep)
		Duel.SetChainLimit(s.chainlm(ep))
	end
end
function s.chainlm(ep)
	return function(e,rp,tp)
		return ep~=tp
	end
end

function s.initial_effect(c)
	aux.EnableDualAttribute(c)
    s.immune(c)
	s.cntac(c)
end
