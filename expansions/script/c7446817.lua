--终结恐龙背摔
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	if not s.global_effect then
		s.global_effect=true
		local dgetfieldgroupcount=Duel.GetFieldGroupCount
		Duel.GetFieldGroupCount=(function(tp,s_loc,o_loc)
			local ct=dgetfieldgroupcount(tp,s_loc,o_loc)
			if s_loc&LOCATION_MZONE ~=0 and Duel.IsExistingMatchingCard(s.ctfilter,tp,0,LOCATION_SZONE,1,nil) then
				ct=ct+Duel.GetMatchingGroupCount(s.ctfilter,tp,0,LOCATION_SZONE,nil)
			end
			if o_loc&LOCATION_MZONE ~=0 and Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_SZONE,0,1,nil) then
				ct=ct+Duel.GetMatchingGroupCount(s.ctfilter,tp,LOCATION_SZONE,0,nil)
			end
			return ct
		end)
	end
end
function s.ctfilter(c)
	return c:GetFlagEffect(id)>0
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x11a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.stfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local cg=tc:GetColumnGroup()
		if cg:IsExists(s.stfilter,1,nil,1-e:GetHandlerPlayer()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local cg=cg:Filter(s.stfilter,nil,1-e:GetHandlerPlayer())
			local tc2=cg:GetFirst()
			if #cg>1 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO) tc2=cg:Select(tp,1,1,nil) end
			local zone=1<<tc:GetSequence()
			local oc=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_SZONE,0,nil,tc:GetSequence()):GetFirst()
			if oc then
				Duel.Destroy(oc,REASON_RULE)
			end
			if Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc2:RegisterEffect(e1)
				tc2:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
			end
		end
	end
end
function s.seqfilter(c,seq)
	return c:GetSequence()==seq
end
