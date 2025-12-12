--苍白之月
local m=70002045
local cm=_G["c"..m]
function cm.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_DECK)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(cm.atkcon)
	e2:SetValue(3500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
	function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
	function cm.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		+Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)==0
end