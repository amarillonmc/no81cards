--虚妄之灵·魔
local m=11621108
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(cm.condition)
	--c:RegisterEffect(e1)	
end

cm.SetCard_XWZL=true

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():GetType()-TYPE_SPELL~=0
end