--自奏圣乐·肯忒萝丝
function c98920489.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920489.mat,1,1)
	c:EnableReviveLimit()
--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920489.imcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
--attack redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c98920489.podcond)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
--reflect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetCondition(c98920489.refcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c98920489.mat(c)
	return c:IsLinkSetCard(0x11b) and not c:IsLinkType(TYPE_LINK)
end
function c98920489.imcon(e)
	return e:GetHandler():IsLinkState()
end
function c98920489.podfilter(c)
	return not c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c98920489.podcond(e)
	local tp=e:GetOwnerPlayer()
	return not Duel.IsExistingMatchingCard(c98920489.podfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920489.refcon(e)
	return Duel.GetAttackTarget()==e:GetHandler()
end