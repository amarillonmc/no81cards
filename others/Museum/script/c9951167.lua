--宝具-水天日光天照八野镇石
function c9951167.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9951167.target)
	e1:SetOperation(c9951167.activate)
	c:RegisterEffect(e1)
   --spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9951167.sslimit)
	c:RegisterEffect(e2)
end
function c9951167.filter(c,e,tp)
	return c:IsLinkSetCard(0xba5,0x6ba8) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951167.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951167.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c9951167.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9951167.filter),tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1) then return end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,9951168,0xba5,0x4011,1800,1800,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK)
			and Duel.SelectYesNo(tp,aux.Stringid(9951167,0)) then
			Duel.BreakEffect()
			local c=e:GetHandler()
			for i=1,ft do
				local token=Duel.CreateToken(tp,9951167+i)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetRange(LOCATION_MZONE)
				e3:SetAbsoluteRange(tp,1,0)
				e3:SetTarget(c9951167.splimit)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetValue(c9951167.atlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c9951167.atlimit(e,c)
	return not c:IsCode(9951106)
end
function c9951167.splimit(e,c)
	return not c:IsSetCard(0x3bd2,0x6ba8)
end
function c9951167.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x3bd2,0x6ba8)
end

