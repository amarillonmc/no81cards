--渊猎的狂战士

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
    
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(aux.IsCodeListed,cid),aux.NonTuner())
	c:EnableReviveLimit()
	
	--SpSumGraveRemoveAndEquipFromDeckGrave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
    --synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.slevel)
	c:RegisterEffect(e2)    
	
	--cannot remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_SZONE,0)
	e3:SetTarget(s.nrtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
end

--e1
--SpSumGraveRemoveAndEquipFromDeckGrave

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function s.spfilter(c,e,tp)
    return aux.IsCodeListed(c,cid) 
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function s.eqsfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsType(TYPE_EQUIP)
    and Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>0
    and c:IsFaceupEx()
end

function s.eqmfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsFaceup()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    
    if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    	
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_GRAVE+LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	
    if not (Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqsfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.eqmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,HINTMSG_EQUIP)) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqsg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqsfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local eqmg=Duel.SelectMatchingCard(tp,s.eqmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Equip(tp,eqsg:GetFirst(),eqmg:GetFirst())
end

--e2
--synchro level

function s.slevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	return (4<<16)+lv
end


--e3
--cannot remove

function s.nrtg(e,c)
	return aux.IsCodeListed(c,cid) and c:IsFaceup()
end
