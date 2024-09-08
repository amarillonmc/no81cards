--水之女演员 招财鱼
function c33718009.initial_effect(c)
--你控制的「水之女演员 / Aquaactress」怪兽·「水族馆 / Aquarium」卡成为对手的卡片效果的对象的场合，
--可以受到800点伤害；那个效果无效并破坏。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33718009.condition1)
	e1:SetCost(c33718009.cost)
	e1:SetTarget(c33718009.target)
	e1:SetOperation(c33718009.activate)
	c:RegisterEffect(e1)
--水再演
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33718009.condition2)
	c:RegisterEffect(e2)
--唐鱼
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c33718009.condition3)
	c:RegisterEffect(e3)
end
function c33718009.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718009.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718017) and not Duel.IsPlayerAffectedByEffect(tp,33718001)
end
function c33718009.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33718001) and not Duel.IsPlayerAffectedByEffect(tp,33718017)
end
function c33718009.filter(c)
	return c:IsSetCard(0xcd) or c:IsSetCard(0xce) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp)
end
function c33718009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Damage(tp,800,REASON_COST)
end
function c33718009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33718009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end