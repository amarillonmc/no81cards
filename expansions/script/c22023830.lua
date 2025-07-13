--人理之基 征氏姐妹
function c22023830.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xff1),2,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_DECK,0)
	e2:SetCondition(c22023830.tdcon)
	c:RegisterEffect(e2)
	--base atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22023830.atkcon)
	e3:SetValue(6500)
	c:RegisterEffect(e3)
	--battle indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c22023830.imcon)
	e5:SetValue(c22023830.efilter)
	c:RegisterEffect(e5)
	if not c22023830.global_flag then
		c22023830.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c22023830.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22023830.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsAttackAbove(6500)
end
function c22023830.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.RegisterFlagEffect(tp,22023830,0,0,0)
	end
end
function c22023830.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22023830)>64
end
function c22023830.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(6500)
end
function c22023830.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
