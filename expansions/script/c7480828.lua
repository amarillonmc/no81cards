--水精鳞-深渊多里斯
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,s.matfilter1,nil,nil,aux.NonTuner(Card.IsRace,RACE_AQUA),1,99)
	--hand synchro
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(s.mattg)
	e0:SetValue(s.matval)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.matfilter1(c,syncard)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsTuner(syncard) or c:IsLevel(7))
end
function s.mattg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevel(7)
end
function s.matval(e,c)
	return c==e:GetHandler()
end
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0x74) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.spfilter2(c,e,tp,rc)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER) and not c:IsOriginalCodeRule(rc:GetOriginalCodeRule())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
