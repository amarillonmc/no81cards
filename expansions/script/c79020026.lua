--整合运动·米莎
function c79020026.initial_effect(c)
	--Code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(79020025)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c79020026.sgop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79020026.hdcon)
	e3:SetOperation(c79020026.hdop)
	c:RegisterEffect(e3)
end
function c79020026.sgfil(c)
	return c:GetAttack()>c:GetBaseAttack()
end
function c79020026.sgop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if Duel.IsExistingMatchingCard(c79020026.sgfil,tp,0,LOCATION_MZONE,1,nil) then
	local g=Duel.GetMatchingGroup(c79020026.sgfil,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,1-tp,REASON_EFFECT+REASON_RULE)
end
end
function c79020026.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsControler(1) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c79020026.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c79020026.cfilter,1,nil,zone)
end
function c79020026.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
end
end
