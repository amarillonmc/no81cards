--欢愉魅魔
function c10105554.initial_effect(c)
 --Atk update
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
 --Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105554,1))
e2:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c10105554.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10105554.target)
	e2:SetOperation(c10105554.operation)
	c:RegisterEffect(e2)
end
function c10105554.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x7cdd)
end
function c10105554.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c10105554.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev)
end
function c10105554.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10105554.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Recover(tp,3000,REASON_EFFECT)
		Duel.Recover(1-tp,1500,REASON_EFFECT)
	end
end