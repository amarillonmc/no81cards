--教导的神使 龙雅
function c12057811.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c12057811.mfilter,c12057811.xyzcheck,2,2)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12057811.immcon1)
	e1:SetValue(c12057811.efilter1)
	c:RegisterEffect(e1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c12057811.immcon1)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(12057811,0))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12057811)
	e2:SetCondition(c12057811.discon)
	e2:SetCost(c12057811.discost)
	e2:SetTarget(c12057811.distg)
	e2:SetOperation(c12057811.disop)
	c:RegisterEffect(e2)
	--xx
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12057811,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,22057811)
	e3:SetCondition(c12057811.xxcon)
	e3:SetTarget(c12057811.xxtg)
	e3:SetOperation(c12057811.xxop)
	c:RegisterEffect(e3)
end
function c12057811.mfilter(c,xyzc)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0x145,0x16b)
end
function c12057811.xyzcheck(g)
	return true 
end
function c12057811.immcon1(e)
	return e:GetHandler():GetOverlayCount()>0 
end
function c12057811.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c12057811.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c12057811.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12057811.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1500)
	end
end
function c12057811.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
		and Duel.Destroy(eg,REASON_EFFECT)~=0 then 
	Duel.Damage(1-tp,1500,REASON_EFFECT)
	end
end
function c12057811.xxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c12057811.tdfil(c)  
	return c:IsAbleToDeck() and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c12057811.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057811.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,1,nil) end 
	local g=Duel.GetMatchingGroup(c12057811.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c12057811.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057811.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	if g:GetCount()>0 then 
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
		--change damage
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
end








