--暴走《战车》·欧辂昂
local m=600012475
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
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)
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

function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.TossDice(tp,1)
	if d1=1 or d1=6 then
		Duel.Damage(1-tp,3000,REASON_EFFECT)
	end
	if d1=2 or d1=5 then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	if d1=3 or d1=4 then
		Duel.Damage(tp,3000,REASON_EFFECT)
	end
end