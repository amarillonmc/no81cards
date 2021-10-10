--方舟骑士·疾件歌者 空
function c82567841.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82567841.pcon)
	e2:SetTarget(c82567841.splimit)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c82567841.atkcon)
	e3:SetTarget(c82567841.atktg)
	e3:SetValue(c82567841.atkval)
	c:RegisterEffect(e3)
	--sleep
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567841,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_MSET+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c82567841.indtg)
	e4:SetCost(c82567841.indcost)
	e4:SetOperation(c82567841.indop)
	c:RegisterEffect(e4)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567841.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82567841.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82567841.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c82567841.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsSetCard(0x825)
end
function c82567841.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if c:GetAttack()<d:GetAttack() then
		return 1000
	else return 0 end
end
function c82567841.filter(c)
	return c:IsFaceup() 
end
function c82567841.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,8,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,8,REASON_COST)
end
function c82567841.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567841.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c82567841.indop(e,tp,eg,ep,ev,re,r,rp)
	
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	local sg=Duel.GetMatchingGroup(c82567841.filter,tp,0,LOCATION_MZONE,nil)
	local tc=sg:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_TRIGGER)
		e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetValue(1)
		tc:RegisterEffect(e4)
		tc=sg:GetNext()
   end
end