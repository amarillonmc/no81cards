--二体的堤丰
function c76200236.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76200236+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c76200236.cost)
	e1:SetTarget(c76200236.target)
	e1:SetOperation(c76200236.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(76200236,ACTIVITY_SPSUMMON,c76200236.counterfilter)
end
function c76200236.counterfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c76200236.cfilter(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsFaceupEx()
		and Duel.GetMZoneCount(tp,c)>0
end
function c76200236.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(76200236,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c76200236.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76200236.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c76200236.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c76200236.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_DRAGON)
end
function c76200236.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c76200236.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c76200236.spfilter,tp,0x32,0,nil,e,tp)
	if chk==0 then return g:IsExists(Card.IsSetCard,1,nil,0x725a) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x32)
end
function c76200236.gcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x725)
end
function c76200236.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c76200236.spfilter),tp,0x32,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and #g>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c76200236.gcheck,false,1,math.min(2,ft))
		if sg then
			local tc=sg:GetFirst()
			while tc do
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
					--cannot trigger
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetRange(LOCATION_MZONE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
				tc=sg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end