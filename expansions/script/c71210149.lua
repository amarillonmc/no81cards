--闇邪咏奏-闇邪奏谕魔帝
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,71210119,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),1,true,true)
	if not s.global_flag then
		s.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
	s.cost(c)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(id) then
			local p=tc:GetSummonPlayer()
			Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.splimit(e,c)
	return c:IsCode(id) and c:IsLocation(LOCATION_EXTRA)
end

function s.cost(c)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.costcon)
	e1:SetCost(s.costchk)
	e1:SetOperation(s.costop)
	c:RegisterEffect(e1)
	--accumulate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FLAG_EFFECT+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(s.costcon)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
end
function s.costcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,id)
	return Duel.CheckLPCost(tp,ct*800)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end