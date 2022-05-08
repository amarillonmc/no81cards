local m=25000010
local cm=_G["c"..m]
cm.name="在流放地"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_RELEASE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.mtcon)
	e5:SetOperation(cm.mtop)
	c:RegisterEffect(e5)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsSummonPlayer,1,nil,tp) then
		Duel.Hint(HINT_CARD,0,m)
		local g1=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
		Duel.Release(g1,REASON_RULE)
	end
	if eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) then
		Duel.Hint(HINT_CARD,0,m)
		local g2=Duel.SelectReleaseGroup(1-tp,nil,1,1,nil)
		Duel.Release(g2,REASON_RULE)
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and e:GetHandler():GetOriginalCode()==m
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
