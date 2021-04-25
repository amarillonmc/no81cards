--陷阵营将军 高顺
function c9330004.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	--change name
	aux.EnableChangeCode(c,9330001,LOCATION_MZONE+LOCATION_GRAVE)
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
	--atk & def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c9330004.filter1)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--immune effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetTarget(c9330004.etarget)
	e5:SetValue(c9330004.efilter2)
	c:RegisterEffect(e5)
	--Negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9330004,0))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c9330004.discon)
	e6:SetCost(c9330004.discost)
	e6:SetTarget(c9330004.distg)
	e6:SetOperation(c9330004.disop)
	c:RegisterEffect(e6)
end
function c9330004.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and not te:GetOwner():IsSetCard(0xf9c)
end
function c9330004.filter1(e,c)
	return c:IsSetCard(0xf9c) and not c:IsCode(9330001)
end
function c9330004.etarget(e,c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSetCard(0xf9c)
end
function c9330004.efilter2(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9330004.cfilter(c)
	return (c:IsType(TYPE_TUNER) and c:IsSetCard(0xf9c)) or c:IsType(TYPE_TRAP)
end
function c9330004.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		   and c:GetOverlayGroup():IsExists(c9330004.cfilter,1,nil)
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











