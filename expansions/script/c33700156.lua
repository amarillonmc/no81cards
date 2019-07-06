--甜蜜枪兵
function c33700156.initial_effect(c)
	   --direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c33700156.dircon)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c33700156.con)
	e2:SetOperation(c33700156.op)
	c:RegisterEffect(e2)
end
function c33700156.dircon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<Duel.GetLP(1-e:GetHandlerPlayer())
end
function c33700156.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and Duel.GetAttackTarget()==nil and Duel.GetLP(e:GetHandlerPlayer())<Duel.GetLP(1-e:GetHandlerPlayer())
end
function c33700156.op(e,tp,eg,ep,ev,re,r,rp)
	if ev>0 then
	Duel.ChangeBattleDamage(ep,0)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
end