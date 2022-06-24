--征冥天的持剑兵
function c67200606.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--setp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200606,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c67200606.stcost)
	e1:SetTarget(c67200606.sttg)
	e1:SetOperation(c67200606.stop)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200606,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200606.chcon)
	e2:SetTarget(c67200606.chtg)
	e2:SetOperation(c67200606.chop)
	c:RegisterEffect(e2)
	--become material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c67200606.condition)
	e3:SetOperation(c67200606.operation)
	c:RegisterEffect(e3)	 
end
--
--
function c67200606.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function c67200606.psfilter(c)
	return c:IsSetCard(0x677) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL) and not c:IsForbidden() and not c:IsCode(67200606)
end
function c67200606.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200606.psfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c67200606.stop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200606.psfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200606.chcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return Duel.GetTurnPlayer()==tp and (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_HAND)
end
function c67200606.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200606.filter1,rp,0,LOCATION_ONFIELD,1,nil) end
end
function c67200606.chtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200606.filter1,rp,0,LOCATION_ONFIELD,1,nil) end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(67200606,3))
end
function c67200606.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c67200606.repop)
end
function c67200606.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c67200606.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c67200606.filter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--
function c67200606.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c67200606.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc and rc:IsSetCard(0x677) and not rc:IsCode(67200606) do
		if rc:GetFlagEffect(67200606)==0 then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(67200606,1))
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_CHAINING)
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCountLimit(1)
			e2:SetCondition(c67200606.chcon)
			e2:SetTarget(c67200606.chtg1)
			e2:SetOperation(c67200606.chop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
			rc:RegisterFlagEffect(67200606,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=eg:GetNext()
	end
end

