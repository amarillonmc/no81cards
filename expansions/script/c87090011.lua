--端午节的觉醒虫师
function c87090011.initial_effect(c)
		  --xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c87090011.ovfilter,aux.Stringid(87090011,0),2,c87090011.xyzop)
	c:EnableReviveLimit()

	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87090011,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,87090011)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c87090011.discon)
	e1:SetCost(c87090011.discost)
	e1:SetTarget(c87090011.distg)
	e1:SetOperation(c87090011.disop)
	c:RegisterEffect(e1)
		 --Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87090011,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)   
	e3:SetCountLimit(1,88090011)
	e3:SetCost(c87090011.thcost)
	e3:SetTarget(c87090011.target)
	e3:SetOperation(c87090011.activate)
	c:RegisterEffect(e3)  




end
function c87090011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.CheckLPCost(tp,1000) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,1000)
end
function c87090011.filter(c)
	return c:IsSetCard(0xafa) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and not c:IsCode(87090011)
end
function c87090011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87090011.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c87090011.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87090011.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end

function c87090011.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa) and c:IsType(TYPE_XYZ) and not c:IsCode(87090011)
end
function c87090011.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,87090011)==0 end
	Duel.RegisterFlagEffect(tp,87090011,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end


function c87090011.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c87090011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.CheckLPCost(tp,1000) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,1000)
end
function c87090011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c87090011.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end









