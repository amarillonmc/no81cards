--拾骸械国之王
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e0=aux.AddRitualProcGreater2(c,s.filter,nil,nil,s.matfilter,true)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCode(0)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id)
	e0:SetCost(s.cost)
	c:RegisterEffect(e0)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(s.costchk)
	e1:SetOperation(s.costop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FLAG_EFFECT+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.filter(c)
	return c:IsCode(id)
end
function s.matfilter(c)
	return c:IsRace(RACE_PSYCHO)
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,id)
	return Duel.CheckLPCost(tp,ct*500)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function s.efilter(e,te)
	return not te:GetHandler():IsRace(RACE_PSYCHO) and te:IsActiveType(TYPE_MONSTER)
end
