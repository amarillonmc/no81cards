--葛饰北斋
function c22021860.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e1:SetCondition(c22021860.con1)
	c:RegisterEffect(e1)
	--cannot ACTIVATE
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c22021860.con2)
	e2:SetValue(c22021860.aclimit)
	c:RegisterEffect(e2)
	--cannot spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c22021860.con3)
	e3:SetTarget(c22021860.splimit)
	c:RegisterEffect(e3)
end
function c22021860.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c22021860.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c22021860.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c22021860.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021860.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22021860.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c22021860.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021860.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22021860.cfilter3(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c22021860.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021860.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end