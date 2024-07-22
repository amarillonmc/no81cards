--瓦尔里纳·希望概像 
function c40010240.initial_effect(c)
	aux.AddCodeList(c,40009571)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,40009571),1,1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c40010240.spcost)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c40010240.raval)
	c:RegisterEffect(e2) 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e2:SetValue(function(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_HAND) end)
	c:RegisterEffect(e2)
end
function c40010240.spcost(e,c,tp,st) 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsLevel(12) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_DRAGON) end,tp,LOCATION_MZONE,0,1,nil) 
end
function c40010240.raval(e,c) 
	local tp=e:GetHandlerPlayer() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x3f1a) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode) 
end



