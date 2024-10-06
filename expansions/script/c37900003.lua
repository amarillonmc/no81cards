--神隐的奇迹
function c37900003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END+TIMINGS_CHECK_MONSTER+TIMING_SSET)
	e1:SetCondition(c37900003.con)
	e1:SetTarget(c37900003.tg)
	e1:SetOperation(c37900003.op)
	c:RegisterEffect(e1)
end
function c37900003.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=1000
end
function c37900003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c37900003.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLP(tp)<=1000 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c37900003.mattg)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(c37900003.reop)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e4,tp)
	Duel.RegisterFlagEffect(tp,37900003,0,0,0)
	end
end
function c37900003.mattg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x389)
end
function c37900003.q(c)
	return c:IsSetCard(0x389) and not c:IsAttack(0)
end
function c37900003.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c37900003.q,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
	local atk=tc:GetAttack()
	Duel.Recover(tp,atk,REASON_EFFECT) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	end
	end
end