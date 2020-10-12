local m=82224083
local cm=_G["c"..m]
cm.name="搓澡门师傅"
function cm.initial_effect(c)
	--Double attack  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_EXTRA_ATTACK)  
	e1:SetValue(16777215)  
	c:RegisterEffect(e1) 
end
