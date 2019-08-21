--星坠尘 暗魂
local m=14000282
local cm=_G["c"..m]
cm.card_code_list={14000260}
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsSummonType,SUMMON_TYPE_NORMAL),nil,nil,aux.Tuner(nil),1,99)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.actcon)
	e1:SetValue(cm.actlimit)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsLevelAbove(1)
end
function cm.ffilter(c)
	return c:IsFaceup() and c:IsCode(14000260)
end
function cm.actcon(e)
	local c=e:GetHandler()
	local lv=0
	local mat=c:GetMaterial():Filter(cm.cfilter,nil)
	local tc=mat:GetFirst()
	while tc do
		lv=lv+tc:GetLevel()
		tc=mat:GetNext()
	end
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(cm.ffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) and lv>0
end
function cm.actlimit(e,re,tp)
	local c,rc=e:GetHandler(),re:GetHandler()
	local lv=0
	local mat=c:GetMaterial():Filter(cm.cfilter,nil)
	local tc=mat:GetFirst()
	while tc do
		lv=lv+tc:GetLevel()
		tc=mat:GetNext()
	end
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLevelAbove(lv+1)
end