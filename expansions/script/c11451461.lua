--虚诞衍生物
--21.04.13
local m=11451461
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--temporary remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(m)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11451468)==0
end