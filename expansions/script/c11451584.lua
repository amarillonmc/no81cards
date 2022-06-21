--画地为牢
--21.06.25
local m=11451584
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetValue(cm.disval)
	c:RegisterEffect(e2)
end
function cm.getzone(c,tp)
	local p=c:GetControler()
	local loc=c:GetLocation()
	local seq=c:GetSequence()
	local zone=1<<seq
	if loc&LOCATION_SZONE~=0 then zone=zone<<8 end
	if p~=tp then zone=zone<<16 end
	if zone==0x20 or zone==0x400000 then zone=0x400020 end
	if zone==0x40 or zone==0x200000 then zone=0x200040 end
	return zone
end
function cm.disval(e)
	local g=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD)
	return g:GetSum(cm.getzone,0)
end