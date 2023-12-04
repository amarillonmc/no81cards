--海神龙 熔岩黑龙
function c64501206.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c64501206.mfilter1,c64501206.mfilter2,true)
	c:EnableReviveLimit()
	--destory
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1,64501206)
	e3:SetCondition(c64501206.descon)
	e3:SetTarget(c64501206.destg)
	e3:SetOperation(c64501206.desop)
	c:RegisterEffect(e3)
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(64501206,1))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetTarget(c64501206.atktg)
	e8:SetOperation(c64501206.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c64501206.material_setcode=0x3b
function c64501206.mfilter1(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsFusionType(TYPE_NORMAL) and c:IsLevel(5)
end
function c64501206.mfilter2(c)
	return c:IsFusionSetCard(0x3b)
end
function c64501206.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c64501206.filter(c)
	return c:IsFaceup()
end
function c64501206.desfilter(c)
	return c:IsFaceup() and c:IsAttack(0)
end
function c64501206.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64501206.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c64501206.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c64501206.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c64501206.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local dg=Duel.GetMatchingGroup(c64501206.desfilter,tp,0,LOCATION_MZONE,nil)
	if dg:GetCount()>0 then
		Duel.BreakEffect()
		local ct=Duel.Destroy(dg,REASON_EFFECT)
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function c64501206.atkfilter(c,tp)
	return c:IsControler(tp)
end
function c64501206.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c64501206.atkfilter,1,nil,1-tp) end
	local g=eg:Filter(c64501206.atkfilter,nil,1-tp)
	Duel.SetTargetCard(g)
end
function c64501206.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	local ct=Duel.Destroy(dg,REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end