--人理之诗 炽焰，亦焚尽神灵
function c22024090.initial_effect(c)
	aux.AddCodeList(c,22024050)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22024090+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22024090.condition)
	e1:SetTarget(c22024090.target)
	e1:SetOperation(c22024090.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024090,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22024090.handcon)
	e2:SetCost(c22024090.cost)
	c:RegisterEffect(e2)
	--sunyears
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024090,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,22024030)
	e3:SetCondition(c22024090.spcon)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c22024090.activate1)
	c:RegisterEffect(e3)
end
c22024090.effect_sunyears=true
function c22024090.cfilter(c)
	return (c:IsFaceup() or c:IsPublic()) and c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
end
function c22024090.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22024090.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
end
function c22024090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22024090,4))
end
function c22024090.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.SelectOption(tp,aux.Stringid(22024090,5))
	Duel.Destroy(g,REASON_EFFECT)
end

function c22024090.filter(c)
	return (c:IsFaceup() or c:IsPublic())and c:IsCode(22024050)
end
function c22024090.handcon(e)
	return Duel.IsExistingMatchingCard(c22024090.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c22024090.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and aux.exccon(e)
end
function c22024090.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22024090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22024050)
	Duel.SelectOption(tp,aux.Stringid(22024090,2))
	Duel.SelectOption(tp,aux.Stringid(22024090,3))
end