--宇宙分裂论
function c49966680.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk down
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49966680,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c49966680.spcon)
	e3:SetOperation(c49966680.atkop2)
	c:RegisterEffect(e3)
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49966680,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c49966680.spcon3)
	e3:SetOperation(c49966680.atkop3)
	c:RegisterEffect(e3)
	  --disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c49966680.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function c49966680.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c49966680.atkop2(e,tp,eg,ep,ev,re,r,rp)
	  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	tc=g:GetNext()
end
end
function c49966680.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c49966680.atkop3(e,tp,eg,ep,ev,re,r,rp)
	  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	tc=g:GetNext()
end
end
function c49966680.disable(e,c)
	return c:IsType(TYPE_EFFECT) and not c:IsAttack(c:GetBaseAttack()) 
end