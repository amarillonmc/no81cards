function c4875102.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c4875102.mfilter,c4875102.xyzcheck,5,5,c4875102.ovfilter,aux.Stringid(4875102,0),c4875102.xyzop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c4875102.effcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c4875102.imcon)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c4875102.actlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c4875102.cost)
	e6:SetTarget(c4875102.destg)
	e6:SetOperation(c4875102.desop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.xyzlimit)
	c:RegisterEffect(e7)
end
c4875102.xyz_number=62
function c4875102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c4875102.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c4875102.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c4875102.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c4875102.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c4875102.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c4875102.filter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e),c:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
	end
end
function c4875102.actlimit(e,te,tp)
	return    te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL)
end
function c4875102.imfilter(c)
	return c:IsCode(93717133)
end
function c4875102.imcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c4875102.imfilter,1,nil)
end
function c4875102.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c4875102.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==11
end
function c4875102.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c4875102.ovfilter(c)
	return c:IsFaceup() and c:IsCode(31801517)
end
function c4875102.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4875102.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c4875102.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c4875102.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end