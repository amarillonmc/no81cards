--黯魔法师 夏妮奥露卡
function c67200078.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,67200057,67200058,true,true) 
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c67200078.tgcon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6673))
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c67200078.atkval)
	c:RegisterEffect(e2)
	--atk 0 & recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200078,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200078.target)
	e3:SetOperation(c67200078.operation)
	c:RegisterEffect(e3)   
end
--
function c67200078.tgcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
--
function c67200078.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
--
function c67200078.filter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c67200078.filter1(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c67200078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c67200078.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200078.filter1,tp,0,LOCATION_MZONE,1,nil) and eg:IsExists(c67200078.filter,1,nil,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c67200078.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetBaseAttack())
end
function c67200078.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
