--危机合约·深度渗透
function c79020009.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c79020009.costchange)
	c:RegisterEffect(e2)
	--self Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c79020009.sdcon)
	c:RegisterEffect(e3)
end
function c79020009.costchange(e,re,rp,val)
	if re and (re:GetHandler():IsSetCard(0x3909) or re:GetHandler():IsSetCard(0x3900)) then
		return 0
	else
		return val
	end
end
function c79020009.sdfilter(c)
   return c:IsSetCard(0x3900)
end
function c79020009.sdcon(e)
   return not Duel.IsExistingMatchingCard(c79020009.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end