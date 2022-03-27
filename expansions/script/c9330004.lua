--陷阵营将军
function c9330004.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	--change name
	aux.EnableChangeCode(c,9330001,LOCATION_ONFIELD+LOCATION_GRAVE)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9330004.efilter)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9330004,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c9330004.discon)
	e4:SetCost(c9330004.discost)
	e4:SetTarget(c9330004.distg)
	e4:SetOperation(c9330004.disop)
	c:RegisterEffect(e4)
end
function c9330004.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and not te:GetOwner():IsSetCard(0xaf93)
end
function c9330004.cfilter(c)
	return (c:IsType(TYPE_TUNER) and c:IsSetCard(0xaf93)) or c:IsType(TYPE_TRAP)
end
function c9330004.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and c:GetOverlayGroup():IsExists(c9330004.cfilter,1,nil)
end
function c9330004.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9330004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c9330004.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		if not rc:IsType(TYPE_TRAP) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		elseif
		Duel.SelectYesNo(tp,aux.Stringid(9330004,1)) then
			rc:CancelToGrave()
			Duel.Overlay(c,eg)
			else
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
end











