--征冥天的枪使灵
function c67200602.initial_effect(c)
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
	e1:SetDescription(aux.Stringid(67200602,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200602)
	e1:SetCost(c67200602.stcost)
	e1:SetTarget(c67200602.sttg)
	e1:SetOperation(c67200602.stop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200602,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200602.descon)
	e2:SetOperation(c67200602.desop)
	c:RegisterEffect(e2)  
	--become material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c67200602.condition)
	e3:SetOperation(c67200602.operation)
	c:RegisterEffect(e3)  
end
--
function c67200602.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function c67200602.psfilter(c)
	return c:IsSetCard(0x677) and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL) and not c:IsForbidden() and not c:IsCode(67200602)
end
function c67200602.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200602.psfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) end
end
function c67200602.stop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200602.psfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200602.cfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c67200602.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200602.cfilter,1,nil,1-tp)
end
function c67200602.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,67200602)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--
function c67200602.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c67200602.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc and rc:IsSetCard(0x677) and not rc:IsCode(67200602) do
		if rc:GetFlagEffect(67200602)==0 then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(67200602,1))
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetCountLimit(1)
			e2:SetCondition(c67200602.descon)
			e2:SetOperation(c67200602.desop) 
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
			rc:RegisterFlagEffect(67200602,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=eg:GetNext()
	end
end
