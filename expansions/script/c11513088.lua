--永远与须臾的罪人
local m=11513088
local cm=_G["c"..m]
function c11513088.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11513088,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,11513088)
	e1:SetCondition(c11513088.condition)
	e1:SetCost(c11513088.cost)
	e1:SetTarget(c11513088.target)
	e1:SetOperation(c11513088.operation)
	c:RegisterEffect(e1)
end

function c11513088.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp, LOCATION_ONFIELD, 0)==0
end

function c11513088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEUP) end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function c11513088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_ANCILLARY, nil, 0, 0, 0)
end

function c11513088.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetReset(RESET_PHASE+PHASE_END, 2)
	e1:SetOperation(c11513088.ruleop)
	Duel.RegisterEffect(e1,tp)
end

function c11513088.filter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsLocation(LOCATION_GRAVE)
end
function c11513088.ruleop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c11513088.filter,nil)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g, REASON_EFFECT)
	end
end