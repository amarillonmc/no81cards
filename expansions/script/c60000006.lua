--AiNo.1 漫色幻花
function c60000006.initial_effect(c)
	--超量网络构筑
	aux.AddXyzProcedure(c,nil,3,2,c60000006.ovfilter,aux.Stringid(60000006,0))
	c:EnableReviveLimit()
	--威风抗性
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function c60000006.ovfilter(c)
	return c:IsFaceup()
	and c:IsType(TYPE_LINK)
end
