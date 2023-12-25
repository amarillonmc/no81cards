--人偶·迦瓦娜
function c74590055.initial_effect(c)
	aux.EnableDualAttribute(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LPCOST_CHANGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(aux.IsDualState)
	e1:SetValue(c74590055.costchange)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(74590055)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(aux.IsDualState)
	c:RegisterEffect(e2)
end
function c74590055.costchange(e,re,rp,val)
	if re and re:GetHandler():IsSetCard(0x745) then
		return 0
	else
		return val
	end
end
