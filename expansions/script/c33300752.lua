--秘林诞地 蜂蜜黄蜂
local s,id,o=GetID()
function c33300752.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--double attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o*100000)
	e2:SetOperation(s.daop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.costfil(c)
	return c:IsSetCard(0xc569) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xc569,1,REASON_COST) or Duel.IsExistingMatchingCard(s.costfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	if Duel.IsExistingMatchingCard(s.costfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=Duel.SelectReleaseGroup(tp,s.costfil,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		Duel.RemoveCounter(tp,1,0,0xc569,1,REASON_COST)
	end
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		--e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		--e1:SetValue(LOCATION_REMOVED)
		--c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2,true)
	end
end

function s.daop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.datg)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end
function s.datg(e,c)
	return c:IsRace(RACE_INSECT) and c:IsSetCard(0xc569)
end