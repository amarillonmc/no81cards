--电子化武导
function c11460566.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11460566,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetTarget(c11460566.sptg)
	e1:SetOperation(c11460566.spop)
	c:RegisterEffect(e1)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetCondition(c11460566.condtion)
	e4:SetValue(c11460566.disval)
	c:RegisterEffect(e4)
end
function c11460566.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c11460566.spfilter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c11460566.spfilter1(c,e,tp)
	return c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.IsExistingMatchingCard(c11460566.spfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel())
end
function c11460566.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR) and not c:IsLevel(lv) and c:IsLevelAbove(1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.IsExistingMatchingCard(c11460566.spfilter3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel(),lv)
end
function c11460566.spfilter3(c,e,tp,lv1,lv2)
	return c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR) and not c:IsLevel(lv1) and not c:IsLevel(lv2) and c:IsLevelAbove(1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.IsExistingMatchingCard(c11460566.spfilter4,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel(),lv1,lv2)
end
function c11460566.spfilter4(c,e,tp,lv1,lv2,lv3)
	return c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR) and not c:IsLevel(lv1) and not c:IsLevel(lv2) and not c:IsLevel(lv3) and c:IsLevelAbove(1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c11460566.spfilter5(c,e,tp)
	return c:IsCode(97023549) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c11460566.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsExistingMatchingCard(c11460566.spfilter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c11460566.spfilter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c11460566.spop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11460566.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<5 then return end
	if not Duel.IsExistingMatchingCard(c11460566.spfilter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		or not Duel.IsExistingMatchingCard(c11460566.spfilter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11460566.spfilter1),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11460566.spfilter2),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,tc,e,tp,tc:GetLevel())
		g1:Merge(g2)
		if g2:GetCount()>0 then
			local tc2=g2:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g3=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11460566.spfilter3),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,tc,e,tp,tc:GetLevel(),tc2:GetLevel())
			g1:Merge(g3)
			if g3:GetCount()>0 then
				local tc3=g3:GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g4=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11460566.spfilter4),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,tc,e,tp,tc:GetLevel(),tc2:GetLevel(),tc3:GetLevel())
				g1:Merge(g4)
				if g4:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g5=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11460566.spfilter5),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
					g1:Merge(g5)
					local tc=g1:GetFirst()
					while tc do
						Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UNRELEASABLE_SUM)
						e1:SetValue(1)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
						e2:SetValue(1)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e2)
						tc=g1:GetNext()
					end
					Duel.SpecialSummonComplete()
				end
			end
		end
	end
end
function c11460566.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR))
end
function c11460566.disfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR)
end
function c11460566.condtion(e)
	return Duel.IsExistingMatchingCard(c11460566.disfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11460566.disval(e)
	if e:GetHandlerPlayer()==0 then
		return (1<<0)*0x10000|(1<<2)*0x10000|(1<<4)*0x10000
	else
		return (1<<0)|(1<<2)|(1<<4)
	end
end
