--逆王的萨满
local m=27582580
local cm=_G["c"..m]
	function cm.initial_effect(c)
	  --immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.etarget)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
	function cm.etarget(e,c)
	return c:IsSetCard(0x7381)
end
	function cm.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not c:IsSetCard(0x7381)
end