--对坏兽用决战兵器 喷射杰格
function c11567833.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsSetCard,0xd3),LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11567833.spcon)
	c:RegisterEffect(e1) 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE) 
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd3)) 
	c:RegisterEffect(e2) 
	--indes 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_IMMUNE_EFFECT) 
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetValue(function(e,te) 
	return e:GetOwner()~=te:GetOwner() and te:GetOwner():IsType(TYPE_MONSTER) and te:GetOwner():IsSetCard(0xd3) end) 
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
	e4:SetValue(function(e,c)
	return c and c:IsSetCard(0xd3) end) 
	c:RegisterEffect(e4)
end
function c11567833.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c11567833.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11567833.cfilter,tp,0,LOCATION_MZONE,1,nil)
end




