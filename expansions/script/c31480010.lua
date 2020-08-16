local m=31480010
local cm=_G["c"..m]
cm.name="神欲道胎动"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(cm.condition1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(cm.condition2)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.activate2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_MOVE)
	e5:SetOperation(cm.op)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCondition(cm.setcon)
	c:RegisterEffect(e6)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x1313)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x1313)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if c:IsPreviousLocation(LOCATION_GRAVE) and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
		Duel.SSet(p,c)
		local lp=Duel.GetLP(p)
		Duel.SetLP(p,lp/2)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,nil,1)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end