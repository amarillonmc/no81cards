--刷拉拉剑士
local s,id,o=GetID()
function c98920761.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.hspcon)
	e1:SetValue(s.hspval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.getzone(tp)
	local zone=0
	local lg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	for lc in aux.Next(lg) do
		zone=bit.bor(zone,lc:GetColumnZone(LOCATION_MZONE,tp))
	end
	zone=zone&0x1f
	return zone
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=s.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function s.hspval(e,c)
	local tp=c:GetControler()
	return 0,s.getzone(tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x8f) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		   local e3=Effect.CreateEffect(e:GetHandler())
		   e3:SetType(EFFECT_TYPE_SINGLE)
		   e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		   e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		   e3:SetReset(RESET_PHASE+PHASE_END)
		   e3:SetValue(1)
		   tc:RegisterEffect(e3)
		   local e4=e3:Clone()
		   e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		   tc:RegisterEffect(e4)
		   Duel.SpecialSummonComplete()
		   Duel.BreakEffect()
		end
	end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PLANT)
end