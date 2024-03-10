--黄巾天兵符
function c88800012.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,88800012)
	e1:SetCondition(c88800012.condition)
	e1:SetTarget(c88800012.distg)
	e1:SetOperation(c88800012.disop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(c88800012.condition1)
	c:RegisterEffect(e3)
	--spsummon1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,88800013)
	e2:SetCost(c88800012.spcost1)
	e2:SetTarget(c88800012.settg)
	e2:SetOperation(c88800012.setop)
	c:RegisterEffect(e2)
end
function c88800012.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc01) and c:IsType(TYPE_MONSTER)
end
function c88800012.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c88800012.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c88800012.pcfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xc01)
end
function c88800012.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and not g:IsExists(s.pcfilter,1,nil)
end
function c88800012.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsReleasable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,eg,1,0,0)
	end
end
function c88800012.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Release(eg,REASON_EFFECT)
	end
end
function c88800012.cfilter(c)
	return c:IsSetCard(0xc01) and c:IsDiscardable()
end
function c88800012.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88800012.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c88800012.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c88800012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c88800012.setop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end