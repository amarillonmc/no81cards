--破灭前夕
local m=33701370
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=30
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,100)
	Duel.SetLP(1-tp,100)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(cm.damcon)
	e1:SetOperation(cm.damop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,100,REASON_EFFECT,true)
	Duel.Damage(1-tp,100,REASON_EFFECT,true)
	Duel.RDComplete()
end
