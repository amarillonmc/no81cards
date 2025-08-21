--暗海
function Dark_Sea_counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
Duel.AddCustomActivityCounter(11633000,ACTIVITY_SPSUMMON,Dark_Sea_counterfilter)
function Dark_Sea_Effect(c,id)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(Dark_Sea_spcost)
	e1:SetCondition(Dark_Sea_spcon)
	e1:SetTarget(Dark_Sea_sptg) 
	e1:SetOperation(Dark_Sea_spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(Dark_Sea_pucon)
	e2:SetOperation(Dark_Sea_puop)
	c:RegisterEffect(e2)
end
function Dark_Sea_pucon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()
end
function Dark_Sea_puop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function Dark_Sea_spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11633000,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(Dark_Sea_splimit)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function Dark_Sea_splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function Dark_Sea_spfilter(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or  not c:IsSetCard(0xa220) then return false end
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c.mat_filter then
		mg2=mg2:Filter(c.mat_filter,nil,tp)
	end
	return mg2:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function Dark_Sea_matfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToGrave() and c:IsSetCard(0xa220)
end
function Dark_Sea_spcon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and (e:GetHandler():IsReason(REASON_EFFECT) and (e:GetHandler():GetReasonPlayer()==1-tp or e:GetHandler():IsSetCard(0xa220)))
end
function Dark_Sea_sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		if Duel.GetFlagEffect(tp,11633001)<2 then 
			mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,nil)
		end
		if Duel.GetFlagEffect(tp,11633002)<1 then
			return Duel.IsExistingMatchingCard(Dark_Sea_spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		else
			return Duel.IsExistingMatchingCard(Dark_Sea_spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function Dark_Sea_spop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if Duel.GetFlagEffect(tp,11633001)<2 then 
		mg=Duel.GetMatchingGroup(Dark_Sea_matfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,11633002)<1 then
		sg=Duel.SelectMatchingCard(tp,Dark_Sea_spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	else
		sg=Duel.SelectMatchingCard(tp,Dark_Sea_spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	end
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		mg:RemoveCard(tc)
		
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		aux.GCheckAdditional=function(sg) return sg:GetSum(Card.GetRitualLevel,tc)<=lv end
		local mat=mg:SelectSubGroup(tp,aux.RitualCheckEqual,true,1,99,tc,lv)
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)

		if mat:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.RegisterFlagEffect(tp,11633001,RESET_PHASE+PHASE_END,0,1) end
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		if tc:IsLocation(LOCATION_DECK) then Duel.RegisterFlagEffect(tp,11633002,RESET_PHASE+PHASE_END,0,1) end
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end