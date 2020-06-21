--触手衍生物
function c79029149.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34408491,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(c79029149.atkcon)
	e2:SetOperation(c79029149.atkop)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c79029149.reop)
	c:RegisterEffect(e3)	
end
function c79029149.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle() and ep==tp
end
function c79029149.filter(c)
	return c:IsCode(79029148)
end 
function c79029149.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029149.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	Duel.Recover(tp,ev,REASON_EFFECT)
	end
end
function c79029149.reop(e,tp,eg,ep,ev,re,r,rp)
	 local a=Duel.GetMatchingGroup(c79029149.filter,tp,LOCATION_MZONE,0,nil)
	 local x=a:GetSum(Card.GetAttack)
	 Duel.Recover(tp,x/2,REASON_EFFECT)
end





