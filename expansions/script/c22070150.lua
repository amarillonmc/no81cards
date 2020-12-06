--一站斩必杀刺客
function c22070150.initial_effect(c)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c22070150.wincon)
	e1:SetOperation(c22070150.winop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c22070150.sdcon)
	c:RegisterEffect(e2)
end
function c22070150.wincon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return ep~=tp and Duel.GetAttackTarget()==nil and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<4
end
function c22070150.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_FLYING_ELEPHANT=0xfe
	Duel.Win(tp,WIN_REASON_FLYING_ELEPHANT)
end
function c22070150.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsAttack(c:GetBaseAttack())
end