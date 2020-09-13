--《U咩尊师传》
function c79035006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79035006,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(79035006,1))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,79035006)
	e1:SetTarget(c79035006.sptg)
	e1:SetOperation(c79035006.spop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c79035006.handcon)
	c:RegisterEffect(e2)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79035006.splimit)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(423585,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,79035006)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c79035006.sptg)
	e2:SetOperation(c79035006.spop)
	c:RegisterEffect(e2) 
	--Remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE)
	e4:SetCondition(c79035006.recon)
	e4:SetOperation(c79035006.reop)
	c:RegisterEffect(e4)
		--
		if not c79035006.global_check then
		c79035006.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c79035006.checkop)
		Duel.RegisterEffect(ge1,0)  
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c79035006.checkop)
		Duel.RegisterEffect(ge1,0) 
		end
end
function c79035006.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
	local xp=tc:GetControler()
	local flag=Duel.GetFlagEffectLabel(xp,79035006)
	if flag then
	Duel.SetFlagEffectLabel(xp,79035006,flag+1)
	else
	Duel.RegisterFlagEffect(xp,79035006,RESET_PHASE+PHASE_END,0,1,1)
	end
	tc=eg:GetNext()
	end
end
function c79035006.hfil(c)
	return not c:IsRace(RACE_MACHINE)
end
function c79035006.handcon(e)
	return not Duel.IsExistingMatchingCard(c79035006.hfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_MACHINE)
end
function c79035006.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c79035006.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_MACHINE)
end
function c79035006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c79035006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)  and Duel.IsExistingMatchingCard(c79035006.hfil,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_MACHINE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c79035006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79035006.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
end
function c79035006.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,79035006)==0
end
function c79035006.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,79035006)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end






