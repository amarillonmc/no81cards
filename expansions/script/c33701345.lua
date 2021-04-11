--欲望的调料
local m=33701345
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.ctcon1)
	e4:SetOperation(cm.ctop1)
	c:RegisterEffect(e4)
	
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1,m)
	e:GetHandler():AddCounter(0x1443,eg:GetCount())
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	if g:GetCount()>0 and e:GetHandler():IsCanRemoveCounter(tp,0x1443,3,REASON_EFFECT) and Duel.SelectYesNo(aux.Stringid(m,0)) then
		e:GetHandler():RemoveCounter(tp,0x1443,3,REASON_EFFECT)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function cm.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1,m)
	if e:GetHandler():IsCanRemoveCounter(tp,0x1443,1,REASON_EFFECT) then
		e:GetHandler():RemoveCounter(tp,0x1443,1,REASON_EFFECT)
	else
		local sg=eg:Clone()
		sg:AddCard(e:GetHandler())
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
