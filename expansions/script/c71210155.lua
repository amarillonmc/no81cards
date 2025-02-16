--闇邪咏奏-王权终鸣者
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,71210125,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),1,true,true)
	if not s.global_flag then
		s.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
	s.tg(c)
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

function s.tg(c)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1103)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct,tp,LOCATION_ONFIELD)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
