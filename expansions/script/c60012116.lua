-- 拣选的教员·韦斯
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1b)

	-- ①：有进化指示物时，对方不能把怪兽的效果发动（不限于场上）
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.atkcon)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
end
s.listed_series={0x5624}
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>0
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end