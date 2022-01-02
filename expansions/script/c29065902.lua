--「逆转的机壳」依赖
local m=29065902
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.splimit2)
	c:RegisterEffect(e2)
end
function cm.con(e,tp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),m-1)
end
function cm.con2(e,tp)
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),m-1)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xaa) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.splimit2(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xaa) 
end