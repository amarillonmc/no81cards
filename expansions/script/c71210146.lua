--闇邪咏奏-灵咏械章·间奏魔
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,71210113,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),1,true,true)
	if not s.global_flag then
		s.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
	s.check(c)
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

function s.check(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1111)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,1,nil) end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,nil)
	Duel.ConfirmCards(tp,sg)
	for tc in aux.Next(sg) do
		if tc:IsSetCard(0x897) and bit.band(tc:GetType(),0x20004)==0x20004 then
			Duel.ChangePosition(tc,POS_FACEUP)
		end
	end
end