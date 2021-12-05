local m=53799063
local cm=_G["c"..m]
cm.name="原理主义者 GRFTTA"
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetCondition(cm.con)
	e2:SetValue(cm.limval)
	c:RegisterEffect(e2)
end
function cm.con(e)
	return e:GetHandler():GetSequence()==2
		and not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,1,nil)
end
function cm.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:GetSequence()<5 and rc:GetSequence()~=2
end