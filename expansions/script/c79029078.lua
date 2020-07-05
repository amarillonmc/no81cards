--莱茵生命·术士干员-伊芙利特
function c79029078.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029078.ffilter,3,3,false)  
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.NonTuner(nil),nil,nil,aux.Tuner(nil),2,79029099)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029078.splimit)
	c:RegisterEffect(e2)
	--Destroy fusion
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c79029078.lzcon)
	e3:SetTarget(c79029078.lztg)
	e3:SetOperation(c79029078.lzop)
	c:RegisterEffect(e3)
	--send to grave Synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c79029078.lzcon2)
	e3:SetTarget(c79029078.lztg2)
	e3:SetOperation(c79029078.lzop2)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c79029078.dircon)
	c:RegisterEffect(e4)
	--defdown
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10000020,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(c79029078.atkcon)
	e5:SetTarget(c79029078.atktg)
	e5:SetOperation(c79029078.atkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--cannot target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_ONFIELD)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(10000020,1))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c79029078.atkcon2)
	e8:SetTarget(c79029078.atktg2)
	e8:SetOperation(c79029078.atkop2)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--pendulum
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(13331639,3))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_DESTROYED)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(c79029078.pencon)
	e0:SetTarget(c79029078.pentg)
	e0:SetOperation(c79029078.penop)
	c:RegisterEffect(e0)
	--damage 2000
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetCode(EFFECT_DISABLE_FIELD)
	e11:SetRange(LOCATION_PZONE)
	e11:SetProperty(EFFECT_FLAG_REPEAT)
	e11:SetCountLimit(1)
	e11:SetCondition(c79029078.dircon)
	e11:SetOperation(c79029078.disop)
	c:RegisterEffect(e11)
	--damage 500
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(85562745,0))
	e12:SetCategory(CATEGORY_DAMAGE)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCode(EVENT_DAMAGE)
	e12:SetRange(LOCATION_PZONE)
	e12:SetCondition(c79029078.con)
	e12:SetTarget(c79029078.tg)
	e12:SetOperation(c79029078.op)
	c:RegisterEffect(e12)
end
function c79029078.ffilter(c)
	return c:IsLevelAbove(10)
end
function c79029078.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029078.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029078.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029078.lzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local x=g:GetCount()
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(1-tp,x*1000,REASON_EFFECT)
	end
end
function c79029078.lzcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029078.lztg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029078.lzop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local x=g:GetCount()
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(1-tp,x*1000,REASON_EFFECT)
	end
end
function c79029078.dircon(e)
	return e:GetHandler():GetColumnGroupCount()==0
end
function c79029078.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_ATTACK) and (not e or c:IsRelateToEffect(e))
end
function c79029078.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029078.atkfilter,1,nil,nil,1-tp)
end
function c79029078.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c79029078.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c79029078.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c79029078.atkfilter2(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_DEFENSE) and (not e or c:IsRelateToEffect(e))
end
function c79029078.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029078.atkfilter2,1,nil,nil,1-tp)
end
function c79029078.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c79029078.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c79029078.atkfilter2,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c79029078.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c79029078.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029078.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c79029078.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2000,REASON_EFFECT)
end
function c79029078.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and re and re:GetHandler():GetCode()~=79029078
end
function c79029078.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c79029078.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end