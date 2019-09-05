--不死之王(注：狸子DIY)
function c77770018.initial_effect(c)
  c:SetUniqueOnField(2,1,77770018)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c77770018.spcon)
	c:RegisterEffect(e1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77770018.immunefilter)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c77770018.indes)
	c:RegisterEffect(e3)
	--activate Zombie World
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77770018,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c77770018.accon)
	e4:SetCost(c77770018.cost)
	e4:SetTarget(c77770018.actg)
	e4:SetOperation(c77770018.acop)
	c:RegisterEffect(e4)	
	--Atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c77770018.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
 end
function c77770018.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c77770018.spcon(e)
	return Duel.GetMatchingGroupCount(c77770018.spfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)>=2
end
function c77770018.immunefilter(e,te)
	return te:GetOwner()~=e:GetOwner() and not te:GetHandler():IsRace(RACE_FAIRY) and not te:GetHandler():IsAttribute(ATTRIBUTE_DEVINE)
end
function c77770018.indes(e,c)
	return not c:IsRace(RACE_FAIRY) and not c:IsAttribute(ATTRIBUTE_DEVINE)
end
function c77770018.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and not c:IsCode(77770018)
end
function c77770018.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77770018.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77770018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c77770018.filter(c,tp)
	return c:IsCode(4064256) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c77770018.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77770018.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c77770018.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c77770018.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c77770018.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil,RACE_ZOMBIE)*500
end