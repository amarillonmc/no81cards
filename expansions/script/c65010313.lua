--ANOTHER RIDER KICK
function c65010313.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010313,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65010313)
	e1:SetCondition(c65010313.cecondition)
	e1:SetTarget(c65010313.cetarget)
	e1:SetOperation(c65010313.ceoperation)
	c:RegisterEffect(e1)
end
function c65010313.repop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Damage(tp,1000,REASON_EFFECT)
end
function c65010313.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcda0)
end
function c65010313.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c65010313.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c65010313.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c65010313.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65010313.repop)
end