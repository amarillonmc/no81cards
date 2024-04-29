--
function c21474349.initial_effect(c)
	aux.AddCodeList(c,35563539)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c21474349.etarget)
	e3:SetValue(c21474349.efilter)
	c:RegisterEffect(e3)
end

function c21474349.etarget(e,c)
	return c:IsCode(35563539)
end
function c21474349.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

