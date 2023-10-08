--枪塔的地精
function c67200704.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCost(c67200704.cost)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200704,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c67200704.spcon)
	e1:SetOperation(c67200704.spop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c67200704.atkval)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e6)  
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200704,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCondition(c67200704.descon)
	e3:SetOperation(c67200704.desop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)	
end
--
function c67200704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c67200704.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c67200704.spfilter(c,e,tp)
	return c:IsSetCard(0x5678) and not c:IsForbidden()
end
function c67200704.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.IsExistingMatchingCard(c67200704.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200704.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.Hint(HINT_CARD,0,67200704)
	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
--
function c67200704.atkfilter(c)
	return c:IsSetCard(0x5678) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c67200704.atkval(e,c)
	local a=Duel.GetMatchingGroupCount(c67200704.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ag=Group.Filter(g,Card.IsType,nil,TYPE_MONSTER)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetBaseAttack()
		x=x+y
		tc=ag:GetNext()
	end
	return a*x
end
--
function c67200704.cfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c67200704.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200704.cfilter,1,nil,1-tp) and e:GetHandler():IsDefensePos()
end
function c67200704.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetCount()>0 and eg:GetFirst():IsAttackable() then
		Duel.Hint(HINT_CARD,0,67200704)
		Duel.CalculateDamage(c,eg:GetFirst())
	end
end

