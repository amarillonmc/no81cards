--破天荒伊吕波
function c65130318.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c65130318.detg)
	e1:SetOperation(c65130318.deop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(65130318,2))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65130318)
	e2:SetTarget(c65130318.sptg)
	e2:SetOperation(c65130318.spop)
	c:RegisterEffect(e2)
end
function c65130318.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c65130318.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c65130318.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Group.CreateGroup()
	local og=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c65130318.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65130318.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	end
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c65130318.filter),1-tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		og=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(c65130318.filter),1-tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,1-tp)
	end  
	local sc=sg:GetFirst()
	local oc=og:GetFirst()
	if sc then
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		if not sc:IsAttack(878) or not sc:IsDefense(1157) then
			-- Level 1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			sc:RegisterEffect(e1,true)
			-- Effects are negated
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e3,true)
		end
	end
	if oc then
		Duel.SpecialSummonStep(oc,0,1-tp,1-tp,false,false,POS_FACEUP)
		if not oc:IsAttack(878) or not oc:IsDefense(1157) then
			-- Level 1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			oc:RegisterEffect(e1,true)
			-- Effects are negated
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			oc:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			oc:RegisterEffect(e3,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c65130318.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c65130318.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		 local sg=g:RandomSelect(tp,1)
		 Duel.Destroy(sg,REASON_EFFECT)
	end
end