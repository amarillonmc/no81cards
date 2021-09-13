--AKF-圣护的夜莺-白夜
function c82568087.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c82568087.notunerfilter),1,1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(10)
	e1:SetCondition(c82568087.discon)
	e1:SetTarget(c82568087.distg)
	e1:SetOperation(c82568087.disop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568087,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c82568087.adcost)
	e2:SetCountLimit(1,82568087)
	e2:SetTarget(c82568087.target)
	e2:SetOperation(c82568087.activate)
	e2:SetValue(c82568087.rdval)
	c:RegisterEffect(e2)
	--atklimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e3)
end
function c82568087.notunerfilter(c)
	return c:IsSetCard(0x825) and c:IsRace(RACE_FIEND)
end 
function c82568087.filter(c)
	return  c:IsFaceup() and not c:IsCode(82567786) and not c:IsCode(82567787)  and not c:IsCode(82568087) and not c:IsCode(82568086)
end
function c82568087.rdval(e)
	return e:GetHandler():GetAttack()/2
end
function c82568087.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82568087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82568087.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568087.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82568087.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82568087.filter,tp,LOCATION_MZONE,0,nil)
	local atk=c82568087.rdval(e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c82568087.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex4=re:IsHasCategory(CATEGORY_DESTROY)
	return ((ex3 and not (bit.band(dv3,LOCATION_DECK)==LOCATION_DECK))
		or ex4) and Duel.IsChainDisablable(ev)
end
function c82568087.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c82568087.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
