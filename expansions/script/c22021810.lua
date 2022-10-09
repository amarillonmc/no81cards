--阿比盖尔·威廉姆斯
function c22021810.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--disable search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e1:SetCondition(c22021810.con1)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c22021810.con2)
	e2:SetTarget(c22021810.splimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c22021810.con3)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e4:SetCondition(c22021810.con3)
	c:RegisterEffect(e4)
end
function c22021810.splimit(e,c)
	return c:IsLocation(LOCATION_DECK)
end
function c22021810.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c22021810.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021810.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22021810.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c22021810.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021810.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22021810.cfilter3(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c22021810.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021810.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end