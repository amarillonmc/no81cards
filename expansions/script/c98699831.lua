local m=98699831
local cm=_G["c"..m]
cm.name="增强性危害标志灵"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsCanAddCounter(0x0876,1) and c:IsFaceup() and c:IsSetCard(0x5876) and c:IsType(TYPE_SPELL) and c:GetSequence()<5
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_SZONE,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x0876,1)
		tc=g:GetNext()
	end
end
function cm.hfilter(c)
	return c:IsFaceup() and c:IsCode(98699823)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
