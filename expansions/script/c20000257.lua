--食星鸟的鸣啭
function c20000257.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c20000257.tg2)
	e2:SetValue(c20000257.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c20000257.tg3)
	e3:SetValue(c20000257.val3)
	c:RegisterEffect(e3)
end
--e2
function c20000257.tgf2(c,lv)
	return c:IsFaceup() and c:IsSetCard(0x3fd2) and bit.band(c:GetType(),0x81)==0x81 and c:GetLevel()<lv
end
function c20000257.tg2(e,c)
	return c:IsFaceup() and c:IsSetCard(0x3fd2) and bit.band(c:GetType(),0x81)==0x81 
	and Duel.IsExistingMatchingCard(c20000257.tgf2,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetLevel())
end
function c20000257.val2(e,te)
	return not te:GetOwner():IsType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--e3
function c20000257.tg3(e,c)
	return c:IsFaceup() and c:IsSetCard(0x3fd2) and bit.band(c:GetType(),0x81)==0x81
end
function c20000257.val3(e,te)
	return te:GetOwner():IsType(TYPE_MONSTER) and te:GetOwner():GetLevel()<e:GetHandler():GetLevel()
end