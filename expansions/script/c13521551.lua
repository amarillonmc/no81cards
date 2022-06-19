local m=13521551
local cm=_G["c"..m]
cm.name="魔女人偶 科赛蒂亚"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	--Xyz Summon
	aux.AddXyzProcedure(c,cm.matfilter,1,2,cm.ovfilter,aux.Stringid(m,0))
	--Extra Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
end
function cm.isset(c)
	return c:GetCode()>=13521500 and c:GetCode()<=13521550
end
--Link Summon
function cm.matfilter(c)
	return c:IsXyzType(TYPE_PENDULUM)
end
function cm.ovfilter(c)
	return c:IsFaceup() and cm.isset(c) and c:IsType(TYPE_PENDULUM)
end
--Extra Summon
function cm.target(e,c)
	return c:IsType(TYPE_PENDULUM)
end