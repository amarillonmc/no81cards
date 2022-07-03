local m=15000291
local cm=_G["c"..m]
cm.name="冥河再渡"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.cgcon)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(cm.aclimit)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(cm.cgtg)
	e5:SetCondition(cm.cgcon)
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
end
cm.has_text_type=TYPE_DUAL 
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and not c:IsDualState()
end
function cm.cgcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,3,nil)
end
function cm.cgtg(e,c)
	return bit.band(c:GetType(),TYPE_EFFECT)~=0 and bit.band(c:GetType(),TYPE_DUAL)==0 and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==0
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and bit.band(c:GetType(),TYPE_DUAL)==0 and bit.band(c:GetType(),TYPE_EFFECT)~=0 and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==0
end