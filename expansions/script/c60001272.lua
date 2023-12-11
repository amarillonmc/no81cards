--开眼者·乌诺
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(cm.valcon)
	c:RegisterEffect(e1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,RESET_PHASE+PHASE_END,0,1000)
	end
	if Duel.GetFlagEffect(tp,m)>=6 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TRUE)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end