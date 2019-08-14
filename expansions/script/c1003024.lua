--绀珠传·纯粹的疯狂
function c1003024.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1003024,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1003024)
	e1:SetCondition(c1003024.con)
	e1:SetCost(c1003024.cost)
	e1:SetTarget(c1003024.target)
	e1:SetOperation(c1003024.operation)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1003024)
	e1:SetCondition(c1003024.condition)
	e1:SetCost(c1003024.cost)
	e1:SetTarget(c1003024.target)
	e1:SetOperation(c1003024.operation)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c1003024.value1)
	c:RegisterEffect(e3)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c1003024.value2)
	c:RegisterEffect(e3)
end
function c1003024.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()==1-tp and Duel.GetAttackTarget()==nil
end
function c1003024.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=eg:GetFirst()
	return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0xa200)
end
function c1003024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c1003024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	local atk=tg:GetTextAttack()
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() end
	Duel.SetTargetCard(tg)
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c1003024.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
	local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function c1003024.atkfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa200)
end
function c1003024.value1(e,c)
	return Duel.GetMatchingGroupCount(c1003024.atkfilter0,c:GetControler(),LOCATION_GRAVE,0,nil)*400
end
function c1003024.atkfilter1(c)
	return not c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa200)
end
function c1003024.value2(e,c)
	return Duel.GetMatchingGroupCount(c1003024.atkfilter1,c:GetControler(),LOCATION_GRAVE,0,nil)*-400
end