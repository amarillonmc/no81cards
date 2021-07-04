--懵懂的暗芽
local m=30005030
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(cm.rlevel)
	c:RegisterEffect(e1)
	--yishijiefang
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e2:SetValue(cm.mtval)
	c:RegisterEffect(e2)
	--yishimudchuwai
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--not link
end
function cm.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsAttribute(ATTRIBUTE_DARK) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end

function cm.mtval(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end