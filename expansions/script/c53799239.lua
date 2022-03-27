local m=53799239
local cm=_G["c"..m]
cm.name="莲奈理绪"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetFlagEffect(m)>0 and tp~=Duel.GetTurnPlayer()end)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) then e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OPPO_TURN+RESET_PHASE+PHASE_STANDBY,0,1) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
