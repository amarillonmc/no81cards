local m=15000915
local cm=_G["c"..m]
cm.name="罪名-『暴食』"
function cm.initial_effect(c)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.mtcon)
	e1:SetOperation(cm.mtop)
	c:RegisterEffect(e1)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(cm.reccon)
	e3:SetOperation(cm.recop)
	c:RegisterEffect(e3)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtfilter(c)
	return c:IsFaceup() and c:IsReleasable() and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_CONTINUOUS))
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.Release(g,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and ((bit.band(r,REASON_BATTLE)~=0 and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x5f3e)) or (bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsControler(tp) and re:GetHandler():IsSetCard(0x5f3e)))
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
