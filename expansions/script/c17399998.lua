local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.get_val(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank() end
	if c:IsType(TYPE_LINK) then return c:GetLink() end
	return c:GetLevel()
end
function s.spfilter(sc,e,tp,race,val)
	return sc:IsRace(race) and s.get_val(sc)>val 
		and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.relfilter(c,e,tp)
	local race=c:GetRace()
	local val=s.get_val(c)
	return c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,race,val)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	s.operation_logic(e,tp)
end
function s.operation_logic(e,tp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	if #rg>0 then
		local rc=rg:GetFirst()
		local race=rc:GetRace()
		local val=s.get_val(rc)	  
		if Duel.Release(rc,REASON_EFFECT)~=0 then
			local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,race,val)
			if #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=spg:Select(tp,1,1,nil):GetFirst()
					if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_UNRELEASABLE_SUM)
						e1:SetValue(1)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e1,true)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
						sc:RegisterEffect(e2,true)
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_DISABLE)
						e3:SetCondition(s.discon)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						sc:RegisterEffect(e3,true)
						local e4=e3:Clone()
						e4:SetCode(EFFECT_DISABLE_EFFECT)
						sc:RegisterEffect(e4,true)
					end
				end
			end
		end
	end
end
function s.discon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
		s.operation_logic(e,1-tp)
	end
end