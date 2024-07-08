--转身之蛇 清姬
function c22020120.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020120,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c22020120.condition1)
	e1:SetTarget(c22020120.destg)
	e1:SetOperation(c22020120.desop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020120,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c22020120.condition2)
	e2:SetTarget(c22020120.destg)
	e2:SetOperation(c22020120.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020120,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c22020120.cost)
	e3:SetCondition(c22020120.condition3)
	e3:SetTarget(c22020120.destg)
	e3:SetOperation(c22020120.desop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22020120,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c22020120.cost)
	e4:SetCondition(c22020120.condition4)
	e4:SetTarget(c22020120.destg)
	e4:SetOperation(c22020120.desop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c22020120.desreptg)
	c:RegisterEffect(e5)
end
function c22020120.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SelectOption(tp,aux.Stringid(22020120,3))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0,nil)
end
function c22020120.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c22020120.cfilter(c)
	return c:IsFaceup() and not c:IsCode(c:GetOriginalCodeRule())
end
function c22020120.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22020120.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c22020120.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020120.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c22020120.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980) and not Duel.IsExistingMatchingCard(c22020120.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c22020120.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980) and Duel.IsExistingMatchingCard(c22020120.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c22020120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020120,2))
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22020120.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.GetLP(tp)>=900 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.SelectOption(tp,aux.Stringid(22020120,4))
		Duel.Damage(tp,900,REASON_EFFECT)
		return true
	else return false end
end