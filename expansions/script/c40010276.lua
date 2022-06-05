--激情的骑士 巴古迪马格斯
local m=40010276
local cm=_G["c"..m]
cm.named_with_Ezelferind=1
function cm.Ezel(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ezel
end
function cm.Ezelferind(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ezelferind
end
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)   
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(cm.indcon)
	e2:SetValue(300)
	c:RegisterEffect(e2) 
end
function cm.cfilter(c)
	return c:IsFaceup() and (cm.Ezel(c) or cm.Ezelferind(c))
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.indfilter(c)
	return c:IsFaceup() and cm.Ezel(c)
end
function cm.indcon(e)
	return Duel.IsExistingMatchingCard(cm.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end




