--超量魔法-精英化
function c29010001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c29010001.target)
	e1:SetOperation(c29010001.activate)
	c:RegisterEffect(e1)	 
end
function c29010001.xyzfil(c,e,tp)
	local att=c:GetAttribute()
	local rc=c:GetRace()
	return c:IsSetCard(0x87af) and Duel.IsExistingMatchingCard(c29010001.xzfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,att,rc) and c:IsLevelBelow(6) and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function c29010001.xzfil(c,e,tp,mc,att,rc)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsRace(rc) and c:IsAttribute(att) and c:IsRank(8) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c29010001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local xg=Duel.GetMatchingGroup(c29010001.xyzfil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e,tp)
	if chk==0 then return xg:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29010001.activate(e,tp,eg,ep,ev,re,r,rp)
	local xg=Duel.GetMatchingGroup(c29010001.xyzfil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e,tp)
	if xg:GetCount()>0 then
	local tc=xg:Select(tp,1,1,nil):GetFirst()
	local rc=tc:GetRace()
	local att=tc:GetAttribute()
	if tc:IsLocation(LOCATION_HAND) then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local xc=Duel.SelectMatchingCard(tp,c29010001.xzfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,att,rc):GetFirst()
	Duel.Overlay(xc,tc)
	Duel.SpecialSummonStep(xc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	xc:CompleteProcedure()
	end
end

