local m=31400109
local cm=_G["c"..m]
cm.name="龙幻变幻龙"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetCondition(cm.lvcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.splimit)
	c:RegisterEffect(e2)
	aux.EnablePendulumAttribute(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.splimit2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetTarget(cm.rctg)
	e4:SetValue(RACE_WYRM)
	c:RegisterEffect(e4)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_WYRM) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.lvcon(e)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function cm.spconfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_WYRM)
end
function cm.spcon(e,c,smat,mg)
	local tp=e:GetHandlerPlayer()
	if Duel.GetMatchingGroupCount(cm.spconfilter,tp,LOCATION_PZONE,0,nil)~=2 then return false end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	local num=lsc-rsc
	return num>2 or num<-2
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandlerPlayer()
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	local lv=Duel.AnnounceLevel(tp,lsc+1,rsc-1)
	e:GetLabelObject():SetValue(lv)
end
function cm.splimit2(e,c,tp,sumtp,sumpos)
	return c:IsLevelAbove(e:GetHandler():GetLevel())
end
function cm.rctg(e,c)
	return c:IsLevelBelow(e:GetHandler():GetLevel())
end