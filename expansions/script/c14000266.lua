--星态神·虚核
local m=14000266
local cm=_G["c"..m]
cm.card_code_list={14000260}
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),nil,nil,aux.Tuner(nil),1,99)
	c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.counterop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.econ)
	e2:SetValue(cm.elimit)
	e2:SetLabel(0)
	c:RegisterEffect(e2)
end
function cm.counterop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	if ep~=tp then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cfilter(c)
	return c:IsType(TYPE_TUNER)
end
function cm.ffilter(c)
	return c:IsFaceup() and c:IsCode(14000260)
end
function cm.econ(e)
	local c=e:GetHandler()
	local ct=c:GetMaterial():Filter(cm.cfilter,nil,nil):GetCount()
	return c:GetFlagEffect(m)>=ct and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(cm.ffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end