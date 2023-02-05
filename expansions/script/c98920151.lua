--魔弹射手 刀锋
function c98920151.initial_effect(c)
		--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)   
	--eff gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920151,1))	
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98920151)
	e3:SetOperation(c98920151.effop)
	c:RegisterEffect(e3)
end
function c98920151.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end
function c98920151.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetRange(LOCATION_MZONE)
		e5:SetTargetRange(0,LOCATION_MZONE)
		e5:SetTarget(c98920151.tg5)
		e5:SetCode(EFFECT_DISABLE)
		c:RegisterEffect(e5)
	end
end
function c98920151.tg5(e,c)
	return not  e:GetHandler():GetColumnGroup():IsContains(c)
end
