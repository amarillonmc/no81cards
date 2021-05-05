--卡通电子龙·无限
function c40008529.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_TOON),6,3,c40008529.ovfilter,aux.Stringid(40008529,0))
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c40008529.atkval)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008529,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40008529.con1)
	e2:SetTarget(c40008529.target)
	e2:SetOperation(c40008529.operation)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(c40008529.con2)
	c:RegisterEffect(e6)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008529,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40008529.discon)
	e3:SetCost(c40008529.discost)
	e3:SetTarget(c40008529.distg)
	e3:SetOperation(c40008529.disop)
	c:RegisterEffect(e3)
	local e7=e3:Clone()
	e7:SetCountLimit(1)
	e7:SetCondition(c40008529.discon2)
	c:RegisterEffect(e7)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c40008529.regcon)
	e4:SetOperation(c40008529.atklimit)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c40008529.dircon)
	c:RegisterEffect(e5)	 
end
function c40008529.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x62) and c:IsType(TYPE_XYZ) and c:IsRankBelow(3)
end
function c40008529.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40008529.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008529.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008529.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008529.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008529.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008529.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008529.con1(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c40008529.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c40008529.con2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008529.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c40008529.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c40008529.filter(c,tp)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsType(TYPE_TOKEN)
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c40008529.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40008529.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c40008529.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40008529.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c40008529.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c40008529.discon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c40008529.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c40008529.discon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and not Duel.IsExistingMatchingCard(c40008529.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c40008529.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008529.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c40008529.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
