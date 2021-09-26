--U87·迷惑妹妹
local m=10101001
local cm=_G["c"..m]
function cm.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1222) and not c:IsCode(10101001)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end