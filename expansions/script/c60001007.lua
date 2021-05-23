--空中连接 环空者
function c60001007.initial_effect(c)
	--回路连接！
	aux.AddLinkProcedure(c,nil,2,99,c60001007.lcheck)
	c:EnableReviveLimit()
	--攻击力上升
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c60001007.atkval)
	c:RegisterEffect(e1)
end
function c60001007.atkval(e,c)
	return c:GetLinkedGroupCount()*1000
end