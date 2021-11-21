--幻想鸣奏 流离荒岛
function c79029833.initial_effect(c)
	--remove overlay replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029833,1))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c79029833.rcon)
	e1:SetOperation(c79029833.rop)
	c:RegisterEffect(e1)
end
function c79029833.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsCode(79029823)
		and ep==e:GetOwner():GetOwner() and re:GetActivateLocation()&LOCATION_MZONE~=0
end
function c79029833.rop(e,tp,eg,ep,ev,re,r,rp)
	return ev
end


