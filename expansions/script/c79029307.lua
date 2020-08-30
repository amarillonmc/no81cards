--维多利亚·术士干员-夜烟·黑色迷雾
function c79029307.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pay
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029307.descon)
	e1:SetCost(c79029307.cost)
	e1:SetOperation(c79029307.op)
	c:RegisterEffect(e1)	
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c79029307.atktarget)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,79029307)
	e3:SetCost(c79029307.akcost)
	e3:SetOperation(c79029307.akop)
	c:RegisterEffect(e3)
end
function c79029307.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029307.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	local lp=Duel.GetLP(tp)
	local t={}
	local f=math.floor((lp)/1000)
	local l=1
	while l<=f and l<=20 do
		t[l]=l*1000
		l=l+1
	end
	Debug.Message("太大意可不行哦~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029307,0))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17078030,0))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce)
	e:GetLabelObject():SetLabel(announce)
	e:GetHandler():SetHint(CHINT_NUMBER,announce)
end
function c79029307.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetLabel(e:GetLabel())
	e2:SetTarget(c79029307.atktarget)
	c:RegisterEffect(e2)   
end 
function c79029307.atktarget(e,c)
	return c:GetAttack()<=e:GetLabel() and not c:IsSetCard(0xa900)
end
function c79029307.akcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_PZONE,LOCATION_PZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	local x=Duel.Release(g,REASON_COST)
	e:SetLabel(x)
end
function c79029307.akop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("你觉得自己很强对吧？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029307,1))
	local x=e:GetLabel()
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(x*1000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(x)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end

