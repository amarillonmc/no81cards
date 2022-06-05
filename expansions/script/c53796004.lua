local m=53796004
local cm=_G["c"..m]
cm.name=""
function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.counterop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(cm.econ1)
	e4:SetValue(cm.elimit)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCondition(cm.econ2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
end
function cm.counterop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasCategory(CATEGORY_NEGATE) then return end
	if ep==tp then e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) else e:GetHandler():RegisterFlagEffect(m+500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.econ1(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.econ2(e)
	return e:GetHandler():GetFlagEffect(m+500)~=0
end
function cm.elimit(e,re,tp)
	return re:IsHasCategory(CATEGORY_NEGATE)
end
