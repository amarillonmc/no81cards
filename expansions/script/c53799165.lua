local m=53799165
local cm=_G["c"..m]
cm.name=""
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTarget(cm.target)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCost(cm.spcost)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.matfilter(c)
	return c:IsLinkAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(1)
end
function cm.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.target(e,c)
	return c:GetReasonCard()==e:GetHandler()
end
function cm.spcost(e,c,tp,st)
	local b=0
	if bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK then
		e:SetLabel(1)
		b=Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_HAND,0,1,nil,ATTRIBUTE_WATER)
	else e:SetLabel(0) end
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and b
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if e:GetLabel()==0 then return true end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_HAND,0,1,1,nil,ATTRIBUTE_WATER)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
