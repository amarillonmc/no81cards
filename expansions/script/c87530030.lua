function c87530030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c87530030.condition)
	e1:SetOperation(c87530030.activate)
	c:RegisterEffect(e1)
end
function c87530030.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)>0 or Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)>0 or Duel.GetActivityCount(1-tp,ACTIVITY_FLIPSUMMON)>0
end
function c87530030.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c87530030.imlimit)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c87530030.imlimit(e,c)
	return (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or (c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD))
end


