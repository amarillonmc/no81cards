--枪塔的蜥蜴人
function c67200703.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCost(c67200703.cost)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200703,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c67200703.spcon)
	e1:SetOperation(c67200703.spop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c67200703.atkval)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)	
end
--
function c67200703.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c67200703.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c67200703.spfilter(c,e,tp)
	return c:IsSetCard(0x5678) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200703.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not Duel.IsExistingMatchingCard(c67200703.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200703.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Hint(HINT_CARD,0,67200703)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--
function c67200703.atkfilter(c)
	return c:IsSetCard(0x5678) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c67200703.atkval(e,c)
	local a=Duel.GetMatchingGroupCount(c67200703.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
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
