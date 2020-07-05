--莱茵生命·近卫干员-星极
function c79029076.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029076.splimit)
	c:RegisterEffect(e2)   
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetTarget(c79029076.target)
	e3:SetOperation(c79029076.operation)
	c:RegisterEffect(e3) 
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c79029076.aclimit)
	e4:SetCondition(c79029076.actcon)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c79029076.iop)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetOperation(c79029076.iop2)
	c:RegisterEffect(e6)
end
function c79029076.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029076.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c79029076.operation(e,tp,eg,ep,ev,re,r,rp)
	 local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c79029076.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c79029076.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c79029076.filter(c,e,tp)
	return c:IsSetCard(0xa900)
end
function c79029076.iop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if Duel.IsExistingMatchingCard(c79029076.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) then
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local f=Duel.SelectMatchingCard(tp,c79029076.filter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SendtoHand(f,nil,REASON_COST)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local tc=g:Filter(Card.IsControler,nil,tp):GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetOperation(c79029076.damop)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
end
end
end
function c79029076.damop(e,tp,eg,ep,ev,re,r,rp)
		Duel.ChangeBattleDamage(tp,0)
end
function c79029076.iop2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c79029076.filter,tp,LOCATION_HAND,0,2,nil,e,tp) then
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local f=Duel.SelectMatchingCard(tp,c79029076.filter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.SendtoGrave(f,nil,REASON_COST)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local tc=g:Filter(Card.IsControler,nil,tp):GetFirst()   
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetOperation(c79029076.damop2)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
end
end
end
function c79029076.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
	Duel.Damage(1-tp,ev/2,REASON_EFFECT)
end


