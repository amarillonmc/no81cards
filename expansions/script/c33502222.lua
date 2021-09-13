--冰汽时代 真理守护者
local m=33502222
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1a81),3,4)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.effcon)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(aux.TargetBoolFunction(cm.spfilter,c))
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,tc)
	return c~=tc
end
function cm.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(cm.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(c:GetFieldID())
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(0,1)
		e2:SetTarget(cm.disable)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabel(c:GetFieldID())
		Duel.RegisterEffect(e2,tp)
		Duel.Hint(HINT_CARD,0,m)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and re:GetHandler():GetFieldID()~=e:GetLabel() 
end
function cm.disable(e,c)
	return c:GetFieldID()~=e:GetLabel() 
end
function cm.efilter(e,te)
	return  e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end