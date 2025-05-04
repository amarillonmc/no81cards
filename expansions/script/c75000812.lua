--焰刃纹章士 艾利乌德
function c75000812.initial_effect(c)
	--double damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c75000812.damtg)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)  
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75000812,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_START)
	e4:SetCondition(c75000812.spcon)
	e4:SetCost(c75000812.spcost)
	e4:SetTarget(c75000812.sptg)
	e4:SetOperation(c75000812.spop)
	c:RegisterEffect(e4)
end
--
function c75000812.damtg(e,c)
	return c:IsSetCard(0xa751) and bit.band(c:GetBattleTarget():GetOriginalRace(),RACE_DRAGON)==RACE_DRAGON
end
--
function c75000812.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c75000812.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c75000812.spfilter(c,e,tp,rc)
	return c:IsSetCard(0xa751)
		and not c:IsCode(75000812)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c75000812.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000812.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	local max=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetMZoneCount(tp,c)<2 then max=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,max,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c75000812.spop(e,tp,eg,ep,ev,re,r,rp)
	local max=2
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then max=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75000812.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,max)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end


