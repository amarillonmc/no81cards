--个人行动-反重力模式
function c79029331.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,79029331)
	e1:SetCondition(c79029331.condition)
	e1:SetTarget(c79029331.target)
	e1:SetOperation(c79029331.activate)
	c:RegisterEffect(e1)
	--th
	local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,79029331)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79029331.thtg)
	e3:SetOperation(c79029331.thop)
	c:RegisterEffect(e3)
end
function c79029331.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c79029331.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029331.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c79029331.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c79029331.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.ChangePosition(g,POS_FACEDOWN)   
	Debug.Message("我可是很擅长这个法术的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029331,1))
	end
end
function c79029331.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),1-tp,0)
end
function c79029331.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Debug.Message("想不想试试漂浮在空中的感觉？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029331,2))
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,79029099) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79029331,0)) then
	Debug.Message("轻轻地......嘿咻。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029331,3))
	Duel.SSet(tp,e:GetHandler())
	end
end
























