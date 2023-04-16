--【月】《恋人》·米路缇欧
local m=60001245
local cm=_G["c"..m]
cm.dfc_back_side=m-1
function cm.initial_effect(c)
	Senya.DFCBackSideCommonEffect(c)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.mtcon)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(1-tp)>=666 then
			Duel.SetLP(1-tp,666)
	end 
end