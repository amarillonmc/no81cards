--星尘龙·天才
function c22070190.initial_effect(c)
	aux.AddMaterialCodeList(c,44508094)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.FilterBoolFunction(Card.IsCode,44508094),1,1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22070190,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22070190.discon)
	e1:SetCost(c22070190.cost)
	e1:SetTarget(c22070190.distg)
	e1:SetOperation(c22070190.disop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c22070190.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22070190,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c22070190.atcon)
	e3:SetCost(c22070190.atcost)
	e3:SetOperation(c22070190.atop)
	c:RegisterEffect(e3)
end
c22070190.material_type=TYPE_SYNCHRO
function c22070190.eftg(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c22070190.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c22070190.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c22070190.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22070190.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

function c22070190.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler(),tp,LOCATION_REASON_TOFIELD,0x1f)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22070131,0xa3,0x4011,2500,2000,8,RACE_DRAGON,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function c22070190.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22070131,0xa3,0x4011,2500,2000,8,RACE_DRAGON,ATTRIBUTE_WIND) then return end
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,22070131)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
function c22070190.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0)
end
function c22070190.costfilter(c)
	return c:IsCode(22070131) and c:IsFaceup()
end
function c22070190.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22070190.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c22070190.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22070190.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end