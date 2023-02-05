--侵略的泛发袭击
function c98920163.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920163+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c98920163.condition)
	e1:SetCost(c98920163.cost)
	e1:SetTarget(c98920163.xtg)
	e1:SetOperation(c98920163.xop)
	c:RegisterEffect(e1)	
	Duel.AddCustomActivityCounter(98920163,ACTIVITY_SPSUMMON,c98920163.counterfilter)
end 
function c98920163.counterfilter(c)
	return c:IsSetCard(0xa)
end
function c98920163.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98920163,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c98920163.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98920163.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa)
end
function c98920163.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end   
function c98920163.xfilter(c,e,tp)
	return c:IsSetCard(0xa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920163.xyzfilter(c,e,tp,mg)
	return c:IsSetCard(0xa) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and mg:IsExists(Card.IsXyzLevel,2,nil,c,c:GetRank())
end
function c98920163.xmfilter1(c,e,tp,mg,exg)
	return mg:IsExists(c98920163.xmfilter2,1,c,e,tp,c,exg)
end
function c98920163.xmfilter2(c,e,tp,mc,exg)
	return exg:IsExists(c98920163.xyzfilter,1,nil,e,tp,Group.FromCards(c,mc))
end
function c98920163.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c98920163.xfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c98920163.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:IsExists(c98920163.xmfilter1,1,nil,e,tp,mg,exg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920163.xop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c98920163.xfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c98920163.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if not (Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:IsExists(c98920163.xmfilter1,1,nil,e,tp,mg,exg)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c98920163.xmfilter1,1,1,nil,e,tp,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c98920163.xmfilter2,1,1,tc1,e,tp,tc1,exg)
	sg1:Merge(sg2)
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	local xyzg=Duel.GetMatchingGroup(c98920163.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,sg1)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,sg1)
	end
end
