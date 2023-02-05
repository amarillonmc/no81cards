--摄影机块 摄像头兔
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x14b),2,2)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(s.lmlimit)
	c:RegisterEffect(e1)
	--immune 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.econ)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	
end
function s.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.econ(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetMutualLinkedGroupCount()>0 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetMutualLinkedGroupCount()==0 
end
function s.get_zone(c,seq)
	local zone=0
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,2) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,1) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then zone=bit.replace(zone,0x1,4) end
	if seq==6 and c:IsLinkMarker(LINK_MARKER_TOP) then zone=bit.replace(zone,0x1,3) end
	return zone
end
function s.spfilter(c,e,tp,seq)
	if not (c:IsType(TYPE_LINK) and c:IsRace(RACE_MACHINE)) then return false end
	local zone=s.get_zone(c,seq)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
		and (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_TOFIELD,zone)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c,zone)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,seq) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,seq)
	if g:GetCount()>0 then
		local zone=s.get_zone(g:GetFirst(),seq)
		Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
