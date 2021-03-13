--亡语骑士 不死骑士
function c99988025.initial_effect(c)	
    c:SetUniqueOnField(1,0,99988025)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99988025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99988025)
	e1:SetTarget(c99988025.sptg)
	e1:SetOperation(c99988025.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c99988025.dacon)
	e3:SetTarget(c99988025.datg)
	c:RegisterEffect(e3)
	end
function c99988025.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_DECK) and c:IsSetCard(0x20df) or c:IsControler(1-tp) and c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_ZOMBIE)) and not c:IsCode(99988025) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99988025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99988025.spfilter,tp,LOCATION_DECK,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99988025.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99988025.spfilter,tp,LOCATION_DECK,LOCATION_GRAVE,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c99988025.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c99988025.dacon(e)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return #g>0 and g:FilterCount(c99988025.cfilter,nil)==#g
end
function c99988025.datg(e,c)
	return c:IsRace(RACE_ZOMBIE)
end