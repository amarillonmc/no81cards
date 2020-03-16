--机械龙
function c22510005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c22510005.aclimit)
	e1:SetCondition(c22510005.condition)
	c:RegisterEffect(e1)
end
function c22510005.condition(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
function c22510005.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
